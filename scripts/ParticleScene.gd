extends Node2D

@onready var level = preload("res://scenes/level.tscn")

func _ready():
	var particles_test = get_tree().current_scene.get_children()
	for child in particles_test:
		if child.is_in_group('particles'):
			child.emitting = false
	await get_tree().create_timer(2.0).timeout
	for child in particles_test:
		if child.is_in_group('particles'):
			child.emitting = true
	await get_tree().create_timer(0.5).timeout
	LevelTransition.change_scene(level)
