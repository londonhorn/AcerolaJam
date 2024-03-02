extends Enemy

@onready var animations = $AnimatedSprite2D

func _process(delta):
	
	movement()
	move_and_slide()



func movement():
	velocity.y = 100
	velocity.x = -300
	animations.play('moving')
	if global_position.x <= 750:
		velocity.x = 0
		animations.play('idle')
