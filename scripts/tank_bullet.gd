extends Projectile

func _physics_process(_delta):
	velocity = Vector2.RIGHT.rotated(rotation) * 500
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
