extends Control

@onready var player = $CharacterBase
@onready var money_display = $UI/Money
@onready var current_wave_display = $UI/CurrentWave
@onready var maxed_label = $UI/MaxedLabel
@onready var fireball_controls = $UI/FireballControls
@onready var shield_controls = $UI/ShieldControls

@onready var size_button = $UI/SizeButton
@onready var health_button = $UI/HealthButton
@onready var wave_skip_button = $UI/WaveSkipButton
@onready var wave_refund_button = $UI/RegressButton
@onready var fireball_button = $UI/FireballButton
@onready var shield_button = $UI/ShieldButton

@onready var hover_sound = $ButtonHover
@onready var money_spent_sound = $MoneySpent
@onready var evolve_sound = $EvolveSound
@onready var click_sound = $ButtonClick

@onready var gameplay_level = load("res://scenes/level.tscn")

var mech_left_arm = preload("res://resources/LeftArm.tres")
var mech_right_arm = preload("res://resources/RightArm.tres")

func _ready():
	player.can_move = false
	player.animations.play('floor')
	mech_right_arm.enabled = false
	mech_left_arm.enabled = false

func _process(_delta):
	player.current_health += 100
	
	if Globals.can_fireball:
		fireball_controls.visible = true
	else:
		fireball_controls.visible = false
		
	if Globals.can_shield:
		shield_controls.visible = true
	else:
		shield_controls.visible = false
	
	if Globals.evolution == 3:
		maxed_label.visible = true
	
	money_display_change()
	current_wave_display_change()
	evolution_checks()
	
	size_button_lock()
	health_button_lock()
	wave_skip_button_lock()
	wave_refund_button_lock()
	fireball_button_lock()
	shield_button_lock()

func money_display_change():
	money_display.text = ('Points: ' + str(Globals.total_points))

func current_wave_display_change():
	current_wave_display.text = ('Current Wave: ' + str(Globals.current_wave_increment + 1))

func _on_button_pressed():
	click_sound.play()
	await click_sound.finished
	LevelTransition.change_scene(gameplay_level)

func _on_size_button_pressed():
	if Globals.total_points >= 14:
		money_spent_sound.play()
		Globals.total_points -= 15
		Globals.character_speed += 25

func _on_health_button_pressed():
	if Globals.total_points >= 34:
		money_spent_sound.play()
		Globals.total_points -= 35
		Globals.character_health += 30

func _on_wave_skip_button_pressed():
	if Globals.total_points >= 399:
		money_spent_sound.play()
		Globals.total_points -= 400
		Globals.current_wave_increment += 1

func _on_regress_button_pressed():
	if Globals.current_wave_increment > 0:
		money_spent_sound.play()
		Globals.total_points += 400
		Globals.current_wave_increment -= 1

func _on_fireball_button_pressed():
	if Globals.total_points >= 199:
		money_spent_sound.play()
		Globals.total_points -= 200
		Globals.can_fireball = true

func _on_shield_button_pressed():
	if Globals.total_points >= 700:
		money_spent_sound.play()
		Globals.total_points -= 700
		Globals.can_shield = true

func evolution_checks():
	if Globals.character_speed >= 350 and Globals.character_health >= 400 and Globals.evolution == 0:
		Globals.evolution += 1
		evolve_sound.play()
	elif Globals.character_speed >= 425 and Globals.character_health >= 670 and Globals.evolution == 1:
		Globals.evolution += 1
		evolve_sound.play()
	elif Globals.character_speed >= 500 and Globals.character_health >= 810 and Globals.evolution == 2:
		Globals.evolution += 1
		evolve_sound.play()

func size_button_lock():
	if Globals.evolution == 3:
		size_button.disabled = true
		size_button.text = "MAXED"
	elif Globals.character_speed >= 349 and Globals.evolution <= 0:
		size_button.disabled = true
		size_button.text = "Must Evolve"
	elif Globals.character_speed >= 424 and Globals.evolution <= 1:
		size_button.disabled = true
		size_button.text = "Must Evolve"
	elif Globals.character_speed >= 499 and Globals.evolution <= 2:
		size_button.disabled = true
		size_button.text = "MAXED"
	elif Globals.total_points <= 15:
		size_button.disabled = true
		size_button.text = "Increase Speed
		15 Points"
	else:
		size_button.disabled = false
		size_button.text = "Increase Speed
		15 Points"


func health_button_lock():
	#print(Globals.character_health)
	if Globals.evolution == 3:
		health_button.disabled = true
		health_button.text = "MAXED"
	elif Globals.character_health >= 500 and Globals.evolution <= 0:
		health_button.disabled = true
		health_button.text = "Must Evolve"
	elif Globals.character_health >= 659 and Globals.evolution <= 1:
		health_button.disabled = true
		health_button.text = "Must Evolve"
	elif Globals.character_health >= 809 and Globals.evolution <= 2:
		health_button.disabled = true
		health_button.text = "MAXED"
	elif Globals.total_points <= 35:
		health_button.disabled = true
		health_button.text = "Increase Duration
		35 Points"
	else:
		health_button.disabled = false
		health_button.text = "Increase Duration
		35 Points"


func wave_skip_button_lock():
	if Globals.total_points < 400:
		wave_skip_button.disabled = true
	else:
		wave_skip_button.disabled = false

func wave_refund_button_lock():
	if Globals.current_wave_increment <= 0:
		wave_refund_button.disabled = true
	else:
		wave_refund_button.disabled = false

func fireball_button_lock():
	if Globals.evolution < 1:
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
	if Globals.evolution < 2:
		shield_button.visible = false
	else:
		shield_button.visible = true
	if Globals.total_points < 700:
		shield_button.disabled = true
	else:
		shield_button.disabled = false
	if Globals.can_shield:
		shield_button.visible = false




