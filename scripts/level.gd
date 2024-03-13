extends Node2D

@onready var ground_spawn_markers = $SpawnPoints
@onready var plane_spawn_markers = $SpawnPointsPlanes
@onready var missile_spawn_markers = $SpawnPointsMissiles
@onready var player = $CharacterBase
@onready var score = $UI/VBoxContainer/Score
@onready var wave_counter = $UI/VBoxContainer/Wave
@onready var health_bar = $UI/Health
@onready var spawn_increment_timer = $SpawnTimer
@onready var spawn_total_timer = $WaveTotalTimer
@onready var extra_points_timer = $ExtraTimePoints

@onready var money_sound = $ExtraTimePoints/MoneySpent
@onready var wave_sound = $WaveTotalTimer/WaveSound
@onready var score_label = $UI/PointIncrease
@onready var wave_label = $UI/WaveIncrease

var pet_level = load("res://scenes/pet_level.tscn")

var civilian = preload("res://scenes/civilian.tscn")
var plane = preload("res://scenes/civilian_plane.tscn")
var taxi = preload("res://scenes/taxi.tscn")
var cop = preload("res://scenes/cop.tscn")
var jetpack_cop = preload("res://scenes/jetpack_cop.tscn")
var cop_car = preload("res://scenes/cop_car.tscn")
var soldier = preload("res://scenes/soldier.tscn")
var tank = preload("res://scenes/tank.tscn")
var jet = preload("res://scenes/jet.tscn")
var missile = preload("res://scenes/cruise_missile.tscn")
var missile_warning = preload("res://scenes/missile_warning.tscn")
var boss = preload("res://scenes/statue_mech.tscn")

var time_points: int = 0

var wave_options = [
	{
		"duration":7,
		"types":{
			"civilian":0.45}
	},
	{
		"duration":7,
		"types":{
			"civilian":0.1,
			"plane":0.4}
	},
	{
		"duration":15,
		"types":{
			"civilian":0.1,
			"plane":0.2,
			"taxi":0.3,
			"cop":0.4}
	},
	{
		"duration":15,
		"types":{
			"civilian":0.1,
			"cop":0.3,
			"taxi":0.7,
			"cop_car":1.0}
	},
	{
		"duration":25,
		"types":{
			"cop":0.4,
			"jetpack_cop":1.0,
			"cop_car":1.5}
	},
	{
		"duration":20,
		"types":{
			"cop":0.4,
			"soldier":0.7}
	},
	{
		"duration":15,
		"types":{
			"cop":0.35,
			"soldier":0.7,
			"cop_car":1.0}
	},
	{
		"duration":20,
		"types":{
			"cop":0.35,
			"soldier":0.5,
			"tank":1.0,
			"jetpack_cop":0.3}
	},
	{
		"duration":25,
		"types":{
			"soldier":0.4,
			"tank":0.8,
			"jetpack_cop":0.3}
	},
	{
		"duration":20,
		"types":{
			"soldier":0.3,
			"tank":0.6,
			"missile":1.5}
	},
	{
		"duration":20,
		"types":{
			"missile":0.3}
	},
	{
		"duration":15,
		"types":{
			"jet":1.5,
			"jetpack_cop":1.0,
			"cop_car":0.5}
	},
	{
		"duration":12,
		"types":{
			"missile":0.3}
	},
	{
		"duration":15,
		"types":{
			"jet":0.5,
			"tank":0.5}
	},
	{
		"duration":1,
		"types":{
			"boss":1}
	}
]




func _ready():
	Globals.current_wave = 14
	player.player_death()
	spawn_total_timer.wait_time = wave_options[Globals.current_wave]["duration"]
	spawn_total_timer.start()
	spawn_increment_timer.start()

func _process(_delta):
	score_keep()
	wave_keep()
	
	if Globals.current_wave >= 14:
		extra_points_timer.stop()
		player.health_timer.stop()
		

func _on_wave_total_timer_timeout():
	Globals.current_wave += 1
	if Globals.current_wave >= wave_options.size():
		Globals.current_wave = wave_options.size() - 1
		spawn_total_timer.stop()
		spawn_increment_timer.stop()
		return
	spawn_total_timer.wait_time = wave_options[Globals.current_wave]["duration"]
	wave_label.visible = true
	wave_sound.play()
	await get_tree().create_timer(0.5).timeout
	wave_label.visible = false

func _on_spawn_timer_timeout():
	wave_generation()

func wave_generation():
	var current_spawn_type = wave_options[Globals.current_wave]["types"].keys().pick_random()
	call(current_spawn_type + "_spawn")
	spawn_increment_timer.wait_time = wave_options[Globals.current_wave]["types"][current_spawn_type]


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
	
	if plane_found < 3:
		var plane_instance = plane.instantiate()
		add_child(plane_instance)
		var spawn_points = plane_spawn_markers.get_children()
		var spawn_point = spawn_points[randi() % spawn_points.size()]
		var pos = spawn_point.global_position
		plane_instance.position = pos
	return .45

func taxi_spawn():
	var taxi_found: int = 0
	for child in get_tree().current_scene.get_children():
		if child is Taxi:
			taxi_found += 1
	
	if taxi_found < 1:
		var taxi_instance = taxi.instantiate()
		var missile_warning_instance = missile_warning.instantiate()
		add_child(taxi_instance)
		add_child(missile_warning_instance)
		var spawn_point = $SpawnPointsMissiles/EnemySpawn4
		var pos = spawn_point.global_position
		taxi_instance.position = pos
		missile_warning_instance.position = Vector2(1050, pos.y)
		await get_tree().create_timer(1).timeout
		missile_warning_instance.queue_free()
	return 2.0

func cop_spawn():
	var cop_instance = cop.instantiate()
	add_child(cop_instance)
	var spawn_points = ground_spawn_markers.get_children()
	var spawn_point = spawn_points[randi() % spawn_points.size()]
	var pos = spawn_point.global_position
	cop_instance.position = pos
	return 2.0

func jetpack_cop_spawn():
	var jetpack_cop_instance = jetpack_cop.instantiate()
	add_child(jetpack_cop_instance)
	var spawn_points = plane_spawn_markers.get_children()
	var spawn_point = spawn_points[randi() % spawn_points.size()]
	var pos = spawn_point.global_position
	jetpack_cop_instance.position = pos
	return 2.0

func tank_spawn():
	var tank_found: int = 0
	for child in get_tree().current_scene.get_children():
		if child is Tank:
			tank_found += 1
		
	if tank_found < 4:
		var tank_instance = tank.instantiate()
		add_child(tank_instance)
		var spawn_points = ground_spawn_markers.get_children()
		var spawn_point = spawn_points[randi() % spawn_points.size()]
		var pos = spawn_point.global_position
		tank_instance.position = pos
	return 1.0

func jet_spawn():
	var jet_found: int = 0
	for child in get_tree().current_scene.get_children():
		if child is Jet:
			jet_found += 1
	
	if jet_found < 2:
		var jet_instance = jet.instantiate()
		add_child(jet_instance)
		var spawn_points = plane_spawn_markers.get_children()
		var spawn_point = spawn_points[randi() % spawn_points.size()]
		var pos = spawn_point.global_position
		jet_instance.position = pos
	return 1.0

func missile_spawn():
	var missile_found: int = 0
	for child in get_tree().current_scene.get_children():
		if child is Missile:
			missile_found += 1
	
	if missile_found < 4:
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
	return 1.0

func soldier_spawn():
	var soldier_instance = soldier.instantiate()
	add_child(soldier_instance)
	var spawn_points = ground_spawn_markers.get_children()
	var spawn_point = spawn_points[randi() % spawn_points.size()]
	var pos = spawn_point.global_position
	soldier_instance.position = pos
	return 1.0

func cop_car_spawn():
	var cop_car_found: int = 0
	for child in get_tree().current_scene.get_children():
		if child is CopCar:
			cop_car_found += 1
	
	if cop_car_found < 1:
		var cop_car_instance = cop_car.instantiate()
		var missile_warning_instance = missile_warning.instantiate()
		add_child(cop_car_instance)
		add_child(missile_warning_instance)
		var spawn_point = $SpawnPointsMissiles/EnemySpawn4
		var pos = spawn_point.global_position
		cop_car_instance.position = pos
		missile_warning_instance.position = Vector2(1050, pos.y)
		await get_tree().create_timer(1).timeout
		missile_warning_instance.queue_free()
	return 1.0  

func boss_spawn():
	var boss_found: int = 0
	for child in get_tree().current_scene.get_children():
		if child is Boss:
			boss_found += 1
	
	if boss_found < 1:
		var boss_instance = boss.instantiate()
		boss_instance.level_scene = self
		add_child(boss_instance)
		var spawn_point = $BossSpawn
		var pos = spawn_point.global_position
		boss_instance.position = pos
		$"World Border/CollisionShape2D2".global_position = Vector2(750, 330)
	return 1.0


func score_keep():
	score.text = 'Score: ' + str(player.points)

func wave_keep():
	wave_counter.text = 'Wave: ' + str(Globals.current_wave + 1)

func _on_character_base_character_died():
	LevelTransition.change_scene(pet_level)

func _on_extra_time_points_timeout():
	time_points += 2
	player.points += time_points
	money_sound.play()
	score_label.text = '+' + str(time_points)
	score_label.visible = true
	await get_tree().create_timer(.3).timeout
	score_label.visible = false

