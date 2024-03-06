extends Enemy
class_name CopCar

func process(_delta):
	$AnimatedSprite2D.play('default')

func _physics_process(_delta):
	velocity.x = -1000
	velocity.y = 100
	
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

