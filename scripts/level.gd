extends Node2D

@onready var ground_spawn_markers = $SpawnPoints
@onready var plane_spawn_markers = $SpawnPointsPlanes
@onready var missile_spawn_markers = $SpawnPointsMissiles
@onready var player_spawn_marker = $PlayerSpawn
@onready var spawn_location = $SpawnLocation1
@onready var player = $CharacterBase
@onready var score = $UI/Score
@onready var health_bar = $UI/Health
@onready var spawn_increment_timer = $SpawnTimer
@onready var spawn_total_timer = $WaveTotalTimer

var pet_level = preload("res://scenes/pet_level.tscn")

var plane = preload("res://scenes/civilian_plane.tscn")
var civilian = preload("res://scenes/civilian.tscn")
var tank = preload("res://scenes/tank.tscn")
var missile = preload("res://scenes/cruise_missile.tscn")
var missile_warning = preload("res://scenes/missile_warning.tscn")

var current_wave: int = 0

var wave_options = [
	{
		"duration":10,
		"types":{"civilian":0.45}
	},
	{
		"duration":15,
		"types":{
			"civilian":0.15, 
			"plane":.3}
	}
]




func _ready():
	player.player_death()
	spawn_total_timer.wait_time = wave_options[current_wave]["duration"]
	spawn_total_timer.start()
	spawn_increment_timer.start()

func _process(_delta):
	score_keep()


func _on_wave_total_timer_timeout():
	current_wave += 1
	if current_wave >= wave_options.size():
		current_wave = wave_options.size() - 1
		spawn_total_timer.stop()
		spawn_increment_timer.stop()
		return
	spawn_total_timer.wait_time = wave_options[current_wave]["duration"]

func _on_spawn_timer_timeout():
	wave_generation()

func wave_generation():
	var current_spawn_type = wave_options[current_wave]["types"].keys().pick_random()
	call(current_spawn_type + "_spawn")
	spawn_increment_timer.wait_time = wave_options[current_wave]["types"][current_spawn_type]
	print(spawn_increment_timer.wait_time)

func civilian_spawn():
	var civilian_instance = civilian.instantiate()
	add_child(civilian_instance)
	var spawn_points = ground_spawn_markers.get_children()
	var spawn_point = spawn_points[randi() % spawn_points.size()]
	var pos = spawn_point.global_position
	civilian_instance.position = pos
	return 0.2

func plane_spawn():
	var plane_found: int = 0
	for child in get_tree().current_scene.get_children():
		if child is Plane1:
			plane_found += 1
	
	if plane_found < 2:
		var plane_instance = plane.instantiate()
		add_child(plane_instance)
		var spawn_points = plane_spawn_markers.get_children()
		var spawn_point = spawn_points[randi() % spawn_points.size()]
		var pos = spawn_point.global_position
		plane_instance.position = pos
	return .45

func tank_spawn():
	var tank_found: int = 0
	for child in get_tree().current_scene.get_children():
		if child is Tank:
			tank_found += 1
		
	if tank_found < 2:
		var tank_instance = tank.instantiate()
		add_child(tank_instance)
		var spawn_points = ground_spawn_markers.get_children()
		var spawn_point = spawn_points[randi() % spawn_points.size()]
		var pos = spawn_point.global_position
		tank_instance.position = pos
	return 5.0

func missile_spawn():
	var missile_found: int = 0
	for child in get_tree().current_scene.get_children():
		if child is Missile:
			missile_found += 1
	
	if missile_found < 2:
		var missile_instance = missile.instantiate()
		var missile_warning_instance = missile_warning.instantiate()
		add_child(missile_instance)
		add_child(missile_warning_instance)
		var spawn_points = missile_spawn_markers.get_children()
		var spawn_point = spawn_points[randi() % spawn_points.size()]
		var pos = spawn_point.global_position
		missile_instance.position = pos
		missile_warning_instance.position = Vector2(1050, pos.y)
		await get_tree().create_timer(1).timeout
		missile_warning_instance.queue_free()
	return 2.0


func score_keep():
	score.text = str(player.points)

func _on_character_base_character_died():
	get_tree().change_scene_to_packed(pet_level)
