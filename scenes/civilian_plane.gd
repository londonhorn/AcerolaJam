class_name Plane1
extends Enemy

@onready var death_animation = $AnimationPlayer

func _ready():
	velocity.x = randi_range(-500, -800)

func _process(_delta):
	enemy_death()

func _physics_process(_delta):
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func enemy_death():
	if health <= 0:
		death_animation.play('vehicle_death')
		await death_animation.animation_finished
		queue_free()
