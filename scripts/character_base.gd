extends CharacterBody2D

const SPEED = 1500
const FRICTION = 40
var acceleration_speed = 500

func _physics_process(delta):
	var input_dir: Vector2 = input()
	
	if input_dir != Vector2.ZERO:
		accelerate(input_dir, delta)
	else:
		add_friction()
		
	move_and_slide()


func input() -> Vector2:
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis('left', 'right')
	input_dir = input_dir.normalized()
	return input_dir

#acceleration
func accelerate(direction, delta):
	velocity = velocity.move_toward(SPEED * direction, (acceleration_speed * delta))

#friction
func add_friction():
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
