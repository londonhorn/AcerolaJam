extends Enemy

func _physics_process(_delta):
	velocity.x = randi_range(-500, -800)
	
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
