extends Enemy
class_name Jet

@onready var bullet_scene = preload("res://scenes/tank_bullet.tscn")

@onready var bullet_spawn_marker = $BulletSpawn
@onready var bullet_spawn_marker2 = $BulletSpawn2
@onready var animations = $AnimatedSprite2D
@onready var shoot_timer = $ShootTimer
@onready var move_timer = $MoveTimer
@onready var shoot_sound = $ShootSound
@onready var death_animation = $AnimationPlayer
@onready var shoot_particle = $ShootParticle
@onready var shoot_particle2 = $ShootParticle2

var has_shot: bool = false
var waiting: bool = false
var destination = randi_range(700, 1000)

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
		animations.play('default')
		if move_timer.is_stopped():
			move_timer.start()

func start_moving():
	waiting = false
	velocity.x = -500


func _on_move_timer_timeout():
	destination = -750
	start_moving()


func shoot():
	has_shot = true

	shoot_timer.start()
	var bullet = bullet_scene.instantiate()
	var bullet2 = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	shoot_particle.emitting = true
	shoot_sound.play()
	bullet.global_position = bullet_spawn_marker.global_position
	bullet.look_at(get_tree().get_first_node_in_group('player').global_position)
	await get_tree().create_timer(0.3).timeout
	get_tree().current_scene.add_child(bullet2)
	shoot_particle2.emitting = true
	bullet2.global_position = bullet_spawn_marker2.global_position
	bullet2.look_at(get_tree().get_first_node_in_group('player').global_position)

func _on_shoot_timer_timeout():
	has_shot = false


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func enemy_death():
	if health <= 0:
		death_animation.play('vehicle_death')
		await death_animation.animation_finished
		queue_free()





