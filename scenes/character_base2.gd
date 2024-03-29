extends Enemy

signal character_died
signal health_changed

@onready var animations = $AnimatedSprite2D
@onready var current_health: int = max_health

@export var max_health = 250

const GRAVITY = 1000

var max_velocity_y_floor = -600
var max_velocity_y = -850
var jump_force_floor = -500
var jump_force = -800
var health_points_tracker = 0
var can_move: bool = true

func _ready():
	
	scale += Globals.character_size

func _process(_delta):
	
	animations_player()
	health_point_increase()
	player_death()

func _physics_process(delta):
	velocity.x = 0
	
	if can_move:
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
		elif velocity.y > 150:
			animations.play('flying_falling')

func _on_hit_detection_body_entered(body):
	if body is Enemy and level >= body.level:
		points += body.points
		health_points_tracker += body.points
		body.queue_free()
	else:
		current_health = 0

func _on_health_decrease_timeout():
	current_health = current_health - 5
	print(current_health)
	health_changed.emit(current_health, max_health)

func health_point_increase():
	if health_points_tracker >= 10:
		current_health += 3
		health_points_tracker = 0
	health_changed.emit(current_health, max_health)

func player_death():
	if current_health <= 0:
		Globals.total_points = Globals.total_points + points
		points = 0
		character_died.emit()
