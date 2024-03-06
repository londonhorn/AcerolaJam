extends Enemy

signal character_died
signal health_changed

@onready var animations = $CharacterSprite1
@onready var health_timer = $HealthDecrease

@onready var evolution_sprite_1 = $CharacterSprite1
@onready var shoot_timer = $ShootTimer
@onready var collision1 = $CollisionShape1
@onready var hit_detection_collision = $HitDetection/CollisionShape2D
@onready var fireball_spawn_marker = $FireballMarker
@onready var walking_sound = $WalkingSound
@onready var flying_sound = $FlyingSound

@onready var fireball_scene = preload("res://scenes/fireball.tscn")

@onready var current_health: int = max_health
@export var max_health = 100

const GRAVITY = 1000
const SPEED = 425
const FRICTION = 500

var health_points_tracker = 0
var can_move: bool = true
var has_shot: bool = false

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
	
	scale_change()
	evolve()
	animations_player()
	health_point_increase()
	player_death()
	

func _physics_process(delta):
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
	velocity = SPEED * direction

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
		body.queue_free()
	elif body is Projectile and level >= body.level:
		points += body.points
		health_points_tracker += body.points
		current_health -= body.health
		body.queue_free()
	else:
		current_health = 0

func _on_health_decrease_timeout():
	current_health = current_health - 5
	health_changed.emit(max_health, current_health)

func health_point_increase():
	if health_points_tracker >= 10:
		current_health += 3
		health_points_tracker = 0
	health_changed.emit(max_health, current_health)

func player_death():
	if current_health <= 0:
		Globals.total_points = Globals.total_points + points
		points = 0
		character_died.emit()

func evolve():
	animations.sprite_frames = load(animations_evolution_sprites[Globals.evolution])
	level = Globals.evolution

func scale_change():
	health = Globals.character_health
	scale = Globals.character_size
	collision1.scale = Globals.character_size
	hit_detection_collision.scale = Globals.character_size
	

func fireball_shoot():
	if Globals.evolution >= 2 and has_shot == false and Globals.can_fireball:
		has_shot = true
		shoot_timer.start()
		var fireball = fireball_scene.instantiate()
		fireball.player = self
		get_tree().current_scene.add_child(fireball)
		fireball.global_position = fireball_spawn_marker.global_position

func _on_shoot_timer_timeout():
	has_shot = false

func walk_sound():
	walking_sound.pitch_scale = randf_range(1, 1.2)
	walking_sound.play()

func fly_sound():
	flying_sound.pitch_scale = randf_range(0.95, 1.1)
	flying_sound.play()
