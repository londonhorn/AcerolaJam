extends Control

@onready var level = preload("res://scenes/level.tscn")
@onready var hover_sound = $ButtonHover
@onready var click_sound = $ButtonClick

func _on_play_pressed():
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_packed(level)

func _on_quit_pressed():
	click_sound.play()
	await click_sound.finished
	get_tree().quit()

func _on_play_mouse_entered():
	hover_sound.play()
