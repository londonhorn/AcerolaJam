extends Control

@onready var player = $CharacterBase
@onready var money_display = $UI/Money

@onready var gameplay_level = load("res://scenes/level.tscn")

func _ready():
	player.can_move = false
	player.animations.play('floor')

func _process(_delta):
	money_display_change()
	evolution_checks()

func money_display_change():
	money_display.text = ('Points: ' + str(Globals.total_points))

func _on_button_pressed():
	get_tree().change_scene_to_packed(gameplay_level)

func _on_size_button_pressed():
	if Globals.total_points >= 100:
		Globals.total_points -= 100
		Globals.character_size += Vector2(0.05, 0.05)

func evolution_checks():
	if Globals.character_size >= Vector2(0.3, 0.3) and Globals.evolution == 0:
		Globals.evolution += 1

