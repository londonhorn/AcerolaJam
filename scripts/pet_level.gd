extends Control

@onready var player = $CharacterBase
@onready var money_display = $UI/Money
@onready var current_wave_display = $UI/CurrentWave
@onready var maxed_label = $UI/MaxedLabel
@onready var fireball_controls = $UI/FireballControls
@onready var shield_controls = $UI/ShieldControls

@onready var restart_button = $UI/RestartButton
@onready var size_button = $UI/SizeButton
@onready var health_button = $UI/HealthButton
@onready var wave_skip_button = $UI/WaveSkipButton
@onready var wave_refund_button = $UI/RegressButton
@onready var fireball_button = $UI/FireballButton
@onready var shield_button = $UI/ShieldButton
@onready var hat_button = $UI/HatButton

@onready var hover_sound = $ButtonHover
@onready var money_spent_sound = $MoneySpent
@onready var evolve_sound = $EvolveSound
@onready var click_sound = $ButtonClick



@onready var gameplay_level = load("res://scenes/level.tscn")

func _ready():
	player.can_move = false
	player.animations.play('floor')

func _process(_delta):
	player.has_shot = true
	player.has_shield = true
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
	hat_button_lock()

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
		print(Globals.character_health)

func _on_wave_skip_button_pressed():
	if Globals.total_points >= 399:
		money_spent_sound.play()
		print(Globals.current_wave_increment)
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

func _on_hat_button_pressed():
	if Globals.total_points >= 1500:
		money_spent_sound.play()
		Globals.total_points -= 1500
		Globals.can_hat = true

func evolution_checks():
	if Globals.character_speed >= 275 and Globals.character_health >= 410 and Globals.evolution == 0:
		Globals.evolution += 1
		evolve_sound.play()
	elif Globals.character_speed >= 425 and Globals.character_health >= 680 and Globals.evolution == 1:
		Globals.evolution += 1
		evolve_sound.play()
	elif Globals.character_speed >= 500 and Globals.character_health >= 830 and Globals.evolution == 2:
		Globals.evolution += 1
		evolve_sound.play()

func size_button_lock():
	if Globals.evolution == 3:
		size_button.disabled = true
		size_button.text = "MAXED"
	elif Globals.character_speed >= 274 and Globals.evolution <= 0:
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
	elif Globals.character_health >= 409 and Globals.evolution <= 0:
		health_button.disabled = true
		health_button.text = "Must Evolve"
	elif Globals.character_health >= 679 and Globals.evolution <= 1:
		health_button.disabled = true
		health_button.text = "Must Evolve"
	elif Globals.character_health >= 829 and Globals.evolution <= 2:
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
	if Globals.current_wave_increment == 14:
		wave_skip_button.disabled = true
		wave_skip_button.text = "MAXED"
	elif Globals.total_points < 400:
		wave_skip_button.disabled = true
		wave_skip_button.text = "Permanently Skip a Wave
400 Points"
	else:
		wave_skip_button.disabled = false
		wave_skip_button.text = "Permanently Skip a Wave
400 Points"

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

func hat_button_lock():
	if Globals.evolution < 3:
		hat_button.visible = false
		$UI/HatButtonRight.visible = false
		$UI/HatButtonLeft.visible = false
	else:
		hat_button.visible = true
	if Globals.total_points < 1500:
		hat_button.disabled = true
	else:
		hat_button.disabled = false
	if Globals.can_hat:
		hat_button.visible = false
		$UI/HatButtonRight.visible = true
		$UI/HatButtonLeft.visible = true


func _on_hat_button_right_pressed():
	money_spent_sound.play()
	Globals.hat_tracker += 1
	if Globals.hat_tracker >= player.hat_spriteframes.size():
		Globals.hat_tracker = 0
func _on_hat_button_left_pressed():
	money_spent_sound.play()
	Globals.hat_tracker -= 1
	if Globals.hat_tracker < 0:
		Globals.hat_tracker = player.hat_spriteframes.size() - 1
