extends Node2D

@onready var civilian_spawn_markers = $SpawnPoints
@onready var plane_spawn_markers = $SpawnPointsPlanes
@onready var player = $CharacterBase
@onready var score = $UI/Score

var pet_level = preload("res://scenes/pet_level.tscn")
var civilian = preload("res://scenes/civilian.tscn")
var plane = preload("res://scenes/civilian_plane.tscn")

func _ready():
	player.can_move = true

func _process(_delta):
	score_keep()


func _on_spawn_timer_1_timeout():
	
	var civilian_instance = civilian.instantiate()
	add_child(civilian_instance)
	
	var spawn_points = civilian_spawn_markers.get_children()
	var spawn_point = spawn_points[randi() % spawn_points.size()]
	var pos = spawn_point.global_position
	civilian_instance.position = pos

func _on_spawn_timer_2_timeout():
	
	var plane_instance = plane.instantiate()
	add_child(plane_instance)
	
	var spawn_points = plane_spawn_markers.get_children()
	var spawn_point = spawn_points[randi() % spawn_points.size()]
	var pos = spawn_point.global_position
	plane_instance.position = pos

func score_keep():
	score.text = str(player.points)

func _on_character_base_character_died():
	get_tree().change_scene_to_packed(pet_level)
