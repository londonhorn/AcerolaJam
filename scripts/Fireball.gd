extends Projectile

@onready var animations = $AnimatedSprite2D

var player = null

func _process(_delta):
	animations.play('default')
	level = Globals.evolution

func _physics_process(_delta):
	velocity.x = 750
	velocity.y = 0
	
	move_and_slide()

func _on_hit_detection_body_entered(body):
	if body is Enemy or body is Projectile and level >= body.level:
		player.points += body.points
		player.health_points_tracker += body.points
		body.queue_free()
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

