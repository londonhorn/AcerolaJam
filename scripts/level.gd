extends Node2D

@onready var ground_spawn_markers = $SpawnPoints
@onready var plane_spawn_markers = $SpawnPointsPlanes
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

var current_wave: int = 0

var player_options: Array = [
	"res://scenes/character_base.tscn", 
	"res://scenes/character_base2.tscn"
	]
var enemy_list1: Array = [
	"res://scenes/civilian.tscn",
	"res://scenes/tank.tscn"
]


func _ready():
	player.player_death()

func _process(_delta):
	score_keep()

func _on_wave_total_timer_timeout():
	current_wave += 1
	print('wave done')


func _on_spawn_timer_timeout():
	wave_generation()


func wave_generation():
	if current_wave == 0:
		civilian_spawn()
		spawn_increment_timer.wait_time = .45
		spawn_total_timer.wait_time = 5
	if current_wave == 1:
		civilian_spawn()
		tank_spawn()
		spawn_increment_timer.wait_time = 1
		spawn_total_timer.wait_time = 15
	if current_wave == 2:
		civilian_spawn()
		plane_spawn()

func score_keep():
	score.text = str(player.points)

func _on_character_base_character_died():
	get_tree().change_scene_to_packed(pet_level)

func civilian_spawn():
	var civilian_instance = civilian.instantiate()
	add_child(civilian_instance)
	var spawn_points = ground_spawn_markers.get_children()
	var spawn_point = spawn_points[randi() % spawn_points.size()]
	var pos = spawn_point.global_position
	civilian_instance.position = pos

func plane_spawn():
	var plane_instance = plane.instantiate()
	add_child(plane_instance)
	var spawn_points = plane_spawn_markers.get_children()
	var spawn_point = spawn_points[randi() % spawn_points.size()]
	var pos = spawn_point.global_position
	plane_instance.position = pos

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




