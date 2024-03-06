extends Control

@onready var player = $CharacterBase
@onready var money_display = $UI/Money
@onready var current_wave_display = $UI/CurrentWave

@onready var size_button = $UI/SizeButton
@onready var health_button = $UI/HealthButton
@onready var wave_skip_button = $UI/WaveSkipButton
@onready var fireball_button = $UI/FireballButton
@onready var shield_button = $UI/ShieldButton

@onready var money_spent_sound = $MoneySpent
@onready var evolve_sound = $EvolveSound

@onready var gameplay_level = load("res://scenes/level.tscn")

func _ready():
	player.can_move = false
	player.animations.play('floor')

func _process(_delta):
	player.health += 100
	
	money_display_change()
	current_wave_display_change()
	evolution_checks()
	
	size_button_lock()
	health_button_lock()
	wave_skip_button_lock()
	fireball_button_lock()
	shield_button_lock()

func money_display_change():
	money_display.text = ('Points: ' + str(Globals.total_points))

func current_wave_display_change():
	current_wave_display.text = ('Current Wave: ' + str(Globals.current_wave))

func _on_button_pressed():
	LevelTransition.change_scene(gameplay_level)

func _on_size_button_pressed():
	if Globals.total_points >= 15:
		money_spent_sound.play()
		Globals.total_points -= 15
		Globals.character_size += Vector2(0.05, 0.05)

func _on_health_button_pressed():
	if Globals.total_points >= 35:
		money_spent_sound.play()
		Globals.total_points -= 35
		Globals.character_health += 25

func _on_wave_skip_button_pressed():
	if Globals.total_points >= 150:
		money_spent_sound.play()
		Globals.total_points -= 150
		Globals.current_wave_increment += 1

func _on_fireball_button_pressed():
	if Globals.total_points >= 200:
		money_spent_sound.play()
		Globals.total_points -= 200
		Globals.can_fireball = true

func _on_shield_button_pressed():
	if Globals.total_points >= 300:
		money_spent_sound.play()
		Globals.total_points -= 300
		Globals.can_fireball = true

func evolution_checks():
	if Globals.character_size >= Vector2(1.29, 1.29) and Globals.character_health >= 200 and Globals.evolution == 0:
		Globals.evolution += 1
		evolve_sound.play()
	elif Globals.character_size >= Vector2(1.99, 1.99) and Globals.character_health >= 350 and Globals.evolution == 1:
		Globals.evolution += 1
		evolve_sound.play()

func size_button_lock():
	if Globals.character_size >= Vector2(1.29, 1.29) and Globals.evolution <= 0 or Globals.total_points < 15:
		size_button.disabled = true
	elif Globals.character_size >= Vector2(1.99, 1.99) and Globals.evolution <= 1 or Globals.total_points < 15:
		size_button.disabled = true
	else:
		size_button.disabled = false

func health_button_lock():
	if Globals.character_health >= 200 and Globals.evolution <= 0 or Globals.total_points < 35:
		health_button.disabled = true
	elif Globals.character_health >= 350 and Globals.evolution <= 1 or Globals.total_points < 35:
		health_button.disabled = true
	else:
		health_button.disabled = false

func wave_skip_button_lock():
	if Globals.total_points < 150:
		wave_skip_button.disabled = true
	else:
		wave_skip_button.disabled = false

func fireball_button_lock():
	if Globals.evolution < 2:
		fireball_button.visible = false
	else:
		fireball_button.visible = true
	if Globals.total_points < 200:
		fireball_button.disabled = true
	else:
		fireball_button.disabled = false
	if Globals.can_fireball:
		fireball_button.visible = false

func shield_button_lock():
	if Globals.evolution < 3:
		shield_button.visible = false
	else:
		shield_button.visible = true
	if Globals.total_points < 300:
		shield_button.disabled = true
	else:
		shield_button.disabled = false
	if Globals.can_shield:
		shield_button.visible = false





