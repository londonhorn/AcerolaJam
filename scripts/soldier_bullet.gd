extends Projectile

func _physics_process(_delta):
	velocity = Vector2.RIGHT.rotated(rotation) * 750
	move_and_slide()

func _process(_delta):
	if health <= 0:
		queue_free()
