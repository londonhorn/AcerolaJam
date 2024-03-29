extends Control

@onready var level = preload("res://scenes/level.tscn")
@onready var tutorial_scene = preload("res://scenes/tutorial_scene.tscn")
@onready var hover_sound = $ButtonHover
@onready var click_sound = $ButtonClick

func _on_play_pressed():
	click_sound.play()
	Globals.current_wave_increment = 0
	await click_sound.finished
	LevelTransition.change_scene(tutorial_scene)

func _on_quit_pressed():
	click_sound.play()
	await click_sound.finished
	get_tree().quit()

func _on_play_mouse_entered():
	hover_sound.play()

func _on_play_focus_entered():
	hover_sound.play()

func _on_return_button_pressed():
	click_sound.play()
	$Credits.visible = false
	$Credits.set_process_mode(4)
	get_tree().paused = false

func _on_credits_pressed():
	click_sound.play()
	$Credits.visible = true
	$Credits.set_process_mode(3)
	get_tree().paused = true

