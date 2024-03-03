class_name Tank
extends Enemy

@onready var bullet_scene = preload("res://scenes/tank_bullet.tscn")

@onready var bullet_spawn_marker = $BulletSpawn
@onready var animations = $AnimatedSprite2D
@onready var shoot_timer = $ShootTimer

var has_shot: bool = false

func _process(_delta):
	movement()
	move_and_slide()

func movement():
	velocity.y = 100
	velocity.x = -300
	animations.play('moving')
	if global_position.x <= 750:
		velocity.x = 0
		animations.play('idle')
		if not has_shot:
			shoot()

func shoot():
	has_shot = true
	shoot_timer.start()
	await shoot_timer.timeout
	has_shot = false
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = bullet_spawn_marker.global_position

