extends CharacterBody2D

@onready var animations = $CharacterSprite1

const GRAVITY = 1000

var max_velocity_y_floor = -600
var max_velocity_y = -850
var jump_force_floor = -500
var jump_force = -800

func _process(_delta):
	animations_player()

func _physics_process(delta):
	velocity.x = 0
	
	jump(delta)
	move_and_slide()

func jump(delta):
	velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed('jump'):
		if is_on_floor:
			velocity.y = max(velocity.y + jump_force_floor, max_velocity_y_floor)
		else:
			velocity.y = max(velocity.y + jump_force, max_velocity_y)

func animations_player():
	if is_on_floor():
		animations.play('floor')
	elif not is_on_floor():
		if velocity.y < 0:
			animations.play('flying_up')
		elif velocity.y > 0:
			animations.play('flying_falling')
