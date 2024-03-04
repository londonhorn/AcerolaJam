class_name Tank
extends Enemy

@onready var bullet_scene = preload("res://scenes/tank_bullet.tscn")

@onready var bullet_spawn_marker = $BulletSpawn
@onready var animations = $AnimatedSprite2D
@onready var shoot_timer = $ShootTimer
@onready var move_timer = $MoveTimer
@onready var shoot_sound = $ShootSound

var has_shot: bool = false
var waiting: bool = false
var destination: Vector2 = Vector2(750, 0)

func _ready():
	start_moving()

func _process(_delta):
	movement()
	move_and_slide()

func movement():
	if waiting and not has_shot:
		shoot()
	if global_position.x <= destination.x:
		waiting = true
		velocity.x = 0
		animations.play('idle')
		if move_timer.is_stopped():
			move_timer.start()

func start_moving():
	waiting = false
	velocity.y = 100
	velocity.x = -300
	animations.play('moving')

func _on_move_timer_timeout():
	destination.x = -750
	start_moving()
	print('tank should move')

func shoot():
	has_shot = true
	shoot_sound.play()
	shoot_timer.start()
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = bullet_spawn_marker.global_position

func _on_shoot_timer_timeout():
	has_shot = false


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


