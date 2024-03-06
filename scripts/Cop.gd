extends Enemy

@onready var bullet_scene = preload("res://scenes/soldier_bullet.tscn")

@onready var shoot_sound = $ShootSound
@onready var move_timer = $MoveTimer
@onready var shoot_timer = $ShootTimer
@onready var bullet_spawn_marker = $BulletSpawn
@onready var animations = $AnimatedSprite2D
@onready var death_animation = $AnimationPlayer

var has_shot: bool = false
var waiting: bool = false
var destination = randi_range(600, 1000)

func _ready():
	start_moving()

func _process(_delta):
	movement()
	enemy_death()
	move_and_slide()


func movement():
	if waiting and not has_shot:
		shoot()
	if global_position.x <= destination:
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
	destination = -750
	start_moving()


func shoot():
	has_shot = true
	shoot_sound.play()
	shoot_timer.start()
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = bullet_spawn_marker.global_position
	bullet.look_at(get_tree().get_first_node_in_group('player').global_position)


func _on_shoot_timer_timeout():
	has_shot = false


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func enemy_death():
	if health <= 0:
		death_animation.play('death')
		await death_animation.animation_finished
		queue_free()
