extends Projectile
class_name Missile

func _physics_process(_delta):
	velocity.x = -1200
	
	
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
