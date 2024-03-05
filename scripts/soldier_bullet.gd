extends Projectile

func _physics_process(_delta):
	velocity = Vector2.RIGHT.rotated(rotation) * 550
	move_and_slide()
