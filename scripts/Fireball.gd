extends Projectile

var player = null

func _process(_delta):
	level = Globals.evolution

func _physics_process(_delta):
	velocity.x = 1000
	velocity.y = 0
	
	move_and_slide()

func _on_hit_detection_body_entered(body):
	if body is Enemy or body is Projectile and level >= body.level:
		player.points += body.points
		player.health_points_tracker += body.points
		body.health = 0
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

