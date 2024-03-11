extends Projectile
class_name Missile

@onready var death_animation = $AnimationPlayer

func _process(_delta):
	enemy_death()

func _physics_process(_delta):
	velocity.x = -1400
	
	
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func enemy_death():
	if health <= 0:
		death_animation.play('vehicle_death')
		await death_animation.animation_finished
		queue_free()
