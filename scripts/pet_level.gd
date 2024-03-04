extends Control

@onready var player = $CharacterBase
@onready var money_display = $UI/Money
@onready var size_button = $UI/SizeButton
@onready var health_button = $UI/HealthButton

@onready var gameplay_level = load("res://scenes/level.tscn")

func _ready():
	player.can_move = false
	player.animations.play('floor')

func _process(_delta):
	money_display_change()
	evolution_checks()
	size_button_lock()
	health_button_lock()

func money_display_change():
	money_display.text = ('Points: ' + str(Globals.total_points))

func _on_button_pressed():
	get_tree().change_scene_to_packed(gameplay_level)

func _on_size_button_pressed():
	if Globals.total_points >= 100:
		Globals.total_points -= 100
		Globals.character_size += Vector2(0.05, 0.05)
		print(Globals.character_size)

func _on_health_button_pressed():
	if Globals.total_points >= 150:
		Globals.total_points -= 150
		Globals.character_health += 25
		print(Globals.character_health)


func evolution_checks():
	if Globals.character_size >= Vector2(1.29, 1.29) and Globals.character_health >= 200 and Globals.evolution == 0:
		Globals.evolution += 1
	elif Globals.character_size >= Vector2(1.99, 1.99) and Globals.character_health >= 350 and Globals.evolution == 1:
		Globals.evolution += 1

func size_button_lock():
	if Globals.character_size >= Vector2(1.29, 1.29) and Globals.evolution <= 0:
		size_button.disabled = true
	elif Globals.character_size >= Vector2(1.99, 1.99) and Globals.evolution <= 1:
		size_button.disabled = true
	else:
		size_button.disabled = false

func health_button_lock():
	if Globals.character_health >= 200 and Globals.evolution <= 0:
		health_button.disabled = true
	elif Globals.character_health >= 350 and Globals.evolution <= 1:
		health_button.disabled = true
	else:
		health_button.disabled = false

