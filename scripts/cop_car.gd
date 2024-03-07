extends Enemy
class_name CopCar

@onready var  death_animation = $AnimationPlayer

func process(_delta):
	$AnimatedSprite2D.play('default')

func _physics_process(_delta):
	velocity.x = -1200
	velocity.y = 100
	
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func enemy_death():
	if health <= 0:
		death_animation.play('vehicle_death')
		await death_animation.animation_finished
		queue_free()
