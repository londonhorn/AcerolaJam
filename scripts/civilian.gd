extends Enemy

@onready var death_animation = $AnimationPlayer

func _ready():
	$AnimatedSprite2D.play('running')

func _process(_delta):
	enemy_death()

func _physics_process(_delta):
	velocity.x = randi_range(-300, -500)
	velocity.y += 100
	
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func enemy_death():
	if health <= 0:
		death_animation.play('death')
		await death_animation.animation_finished
		queue_free()
