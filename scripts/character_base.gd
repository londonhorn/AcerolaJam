extends Enemy

signal character_died
signal health_changed

@onready var animations = $CharacterSprite1
@onready var health_timer = $HealthDecrease
@onready var point_markers = $PointMarkers

@onready var evolution_sprite_1 = $CharacterSprite1
@onready var shoot_timer = $ShootTimer
@onready var shield_timer = $ShieldTimer
@onready var collision1 = $CollisionShape1
@onready var hit_detection_collision = $HitDetection/CollisionShape2D
@onready var fireball_spawn_marker = $FireballMarker

@onready var small_hit_sound = $SmallHit
@onready var walking_sound = $WalkingSound
@onready var flying_sound = $FlyingSound
@onready var death_sound = $DeathSound
@onready var eating_sound = $EatingSound

@onready var death_particles = $DeathParticles
@onready var animation_player = $AnimationPlayer

@onready var fireball_scene = preload("res://scenes/fireball.tscn")
@onready var shield_scene = preload("res://scenes/shield.tscn")
@onready var point_popup = preload("res://scenes/score_popup.tscn")

@onready var current_health: int = max_health
@export var max_health = 100

const GRAVITY = 1000
const FRICTION = 500

var speed: int = 0
var health_points_tracker = 0
var can_move: bool = true
var is_shielding: bool = false
var has_shot: bool = false
var has_shield: bool = false

var animations_evolution_sprites: Array = [
	"res://sprite_frames_spot/evolution_0.tres", 
	"res://sprite_frames_spot/evolution_1.tres",
	"res://sprite_frames_spot/evolution_2.tres"
	]



func _ready():
	health_changed.emit(max_health, current_health)

func _process(_delta):
	
	if Input.is_action_pressed('Fireball'):
		fireball_shoot()
	if Input.is_action_pressed('Shield'):
		shield_spawn()
	if is_shielding:
		get_tree().call_group('bullets','queue_free')
	
	scale_change()
	evolve()
	animations_player()
	health_point_increase()
	player_death()
	

func _physics_process(_delta):
	var input_dir: Vector2 = Input.get_vector('left', 'right', 'up', 'down')
	
	if input_dir != Vector2.ZERO and can_move:
		accelerate(input_dir)
		move_and_slide()
	else:
		add_friction()

#func jump(delta):
	#velocity.y += GRAVITY * delta
	#if Input.is_action_just_pressed('jump'):
		#fly_sound()
		#if is_on_floor:
			#velocity.y = max(velocity.y + jump_force_floor, max_velocity_y_floor)
		#else:
			#velocity.y = max(velocity.y + jump_force, max_velocity_y)

func accelerate(direction):
	velocity = speed * direction

func add_friction():
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)



func animations_player():
	if is_on_floor():
		animations.play('floor')
		if !walking_sound.is_playing():
			walk_sound()
	elif not is_on_floor():
		walking_sound.stop()
		animations.play('flying_up')

func _on_hit_detection_body_entered(body):
	if body is Enemy and level >= body.level:
		points += body.points
		health_points_tracker += body.points
		eat_sound()
		body.health -= 1
		var label = point_popup.instantiate()
		get_tree().current_scene.add_child(label)
		var spawn_points = point_markers.get_children()
		var spawn_point = spawn_points[randi() % spawn_points.size()]
		var pos = spawn_point.global_position
		label.text = "+" + str(body.points)
		label.global_position = pos
	elif body is Projectile and level >= body.level:
		points += body.points
		health_points_tracker += body.points
		current_health -= body.health
		small_hit_play()
		body.health -= 50
		var tween = create_tween()
		tween.tween_property(animations, "modulate", Color.RED, 0.05)
		tween.tween_property(animations, "modulate", Color.WHITE, 0.05)
		tween.set_loops(1)
	else:
		current_health = 0

func _on_health_decrease_timeout():
	current_health = current_health - 5
	health_changed.emit(max_health, current_health)

func health_point_increase():
	if health_points_tracker >= 5:
		current_health += 3
		health_points_tracker = 0
	health_changed.emit(max_health, current_health)

func player_death():
	if current_health <= 0:
		Globals.total_points = Globals.total_points + points
		points = 0
		animation_player.play('death')
		if !death_sound.is_playing():
			death_sound.play()
		get_tree().paused = true
		await animation_player.animation_finished
		character_died.emit()

func evolve():
	animations.sprite_frames = load(animations_evolution_sprites[Globals.evolution])
	level = Globals.evolution

func scale_change():
	health = Globals.character_health
	speed = Globals.character_speed

func fireball_shoot():
	if Globals.evolution >= 1 and has_shot == false and Globals.can_fireball:
		has_shot = true
		shoot_timer.start()
		var fireball = fireball_scene.instantiate()
		fireball.player = self
		get_tree().current_scene.add_child(fireball)
		fireball.global_position = fireball_spawn_marker.global_position
		fireball.look_at(get_global_mouse_position())
func _on_shoot_timer_timeout():
	has_shot = false

func shield_spawn():
	if Globals.evolution >= 2 and has_shield == false and Globals.can_shield:
		has_shield = true
		shield_timer.start()
		var shield = shield_scene.instantiate()
		shield.player = self
		get_tree().current_scene.add_child(shield)
		is_shielding = true
		await get_tree().create_timer(1).timeout
		is_shielding = false
func _on_shield_timer_timeout():
	has_shield = false


func walk_sound():
	walking_sound.pitch_scale = randf_range(1, 1.2)
	walking_sound.play()

func fly_sound():
	flying_sound.pitch_scale = randf_range(0.95, 1.1)
	flying_sound.play()

func eat_sound():
	eating_sound.pitch_scale = randf_range(0.9, 1.1)
	eating_sound.play()

func small_hit_play():
	small_hit_sound.pitch_scale = randf_range(0.85, 1)
	small_hit_sound.play()


