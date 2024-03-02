extends Control

@onready var player = $CharacterBase
@onready var money_display = $UI/Money

@onready var gameplay_level = load("res://scenes/level.tscn")

func _ready():
	player.can_move = false
	player.animations.play('floor')

func _process(_delta):
	money_display_change()

func money_display_change():
	money_display.text = str(Globals.total_points)

func _on_button_pressed():
	get_tree().change_scene_to_packed(gameplay_level)

func _on_size_button_pressed():
	if Globals.total_points >= 100:
		Globals.total_points -= 100
		Globals.character_size += Vector2(0.1, 0.1)

