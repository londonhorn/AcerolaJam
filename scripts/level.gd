extends Node2D

@onready var civilian_spawn_markers = $SpawnPoints
@onready var player = $CharacterBase
@onready var score = $UI/Score

var civilian = preload("res://scenes/civilian.tscn")

func _process(_delta):
	score_keep()

func _on_spawn_timer_1_timeout():
	
	var civilian_instance = civilian.instantiate()
	add_child(civilian_instance)
	
	var spawn_points = civilian_spawn_markers.get_children()
	var spawn_point = spawn_points[randi() % spawn_points.size()]
	var pos = spawn_point.global_position
	civilian_instance.position = pos

func score_keep():
	score.text = str(player.points)
