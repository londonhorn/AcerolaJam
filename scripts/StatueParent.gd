extends Limb
class_name Boss

@onready var cannon_spawn_marker = $Node2D/BodyParent/Hips/Torso/LeftArm/LeftForearm/LeftArmEnd/Sprite2D/CannonMarker
@onready var gun_spawn_marker = $Node2D/BodyParent/Hips/Torso/RightArm/RightForearm/RightArmEnd/Sprite2D/GunMarker
@onready var skeleton_parent = %BodyParent
@onready var head_sprites = $Node2D/BodyParent/Hips/Torso/Head/HeadSprites
@onready var state_chart = $StateChart
@onready var firebreath_particle = $Node2D/BodyParent/Hips/Torso/Head/HeadSprites/FirebreathEffect
@onready var firebreath_hitbox = $Node2D/BodyParent/Hips/Torso/Head/HeadSprites/FirebreathHitbox
@onready var fire_animations = $Node2D/FireAnimations
@onready var death_animations = $Node2D/DeathAnimations

@onready var left_arm_sound = $Node2D/LeftArmSound
@onready var right_arm_sound = $Node2D/RightArmSound
@onready var firebreath_sound = $Node2D/FireBreathSound

@onready var left_tip = $Node2D/BodyParent/Hips/Torso/LeftArm/LeftForearm/LeftArmEnd
@onready var right_tip = $Node2D/BodyParent/Hips/Torso/RightArm/RightForearm/RightArmEnd

@onready var attack_timer = $AttackTimer
@onready var left_arm_timer = $LeftArmTimer
@onready var right_arm_timer = $RightArmTimer
@onready var both_arms_timer = $BothArmsTimer

@onready var left_arm_hitbox = $Node2D/BodyParent/Hips/Torso/LeftArm/LeftForearm/LeftArmHitbox
@onready var right_arm_hitbox = $Node2D/BodyParent/Hips/Torso/RightArm/RightForearm/RightArmHitbox

var bullet_scene = preload("res://scenes/tank_bullet.tscn")
var small_bullet_scene = preload("res://scenes/soldier_bullet.tscn")
var missile = preload("res://scenes/cruise_missile.tscn")
var missile_warning = preload("res://scenes/missile_warning.tscn")
var mech_left_arm = load("res://resources/LeftArm.tres")
var mech_right_arm = load("res://resources/RightArm.tres")

var outro_scene = load("res://scenes/outro_scene.tscn")

var level_scene = null
var left_has_shot: bool = true
var right_has_shot: bool = true
var firebreathing: bool = false
var can_missile: bool = true
var left_arm_gone: bool = false
var right_arm_gone: bool = false
var destination: int = 1000

var fire_options: Array = [
	"fire_up",
	"fire_down"
]

var attack_options: Array =[
	"firebreath_start",
	"rocket_launch_start",
	"left_arm_start",
	"right_arm_start",
	"both_arms_start"
]

func _ready():
	start_moving()
	$Node2D/BodyParent/Hips/Torso/LeftArm.visible = true
	$Node2D/BodyParent/Hips/Torso/RightArm.visible = true
	var mod_stack = skeleton_parent.get_modification_stack()
	var skl_mod = mod_stack.get_modification(0)
	skl_mod.target_nodepath = skl_mod.target_nodepath
	skl_mod.tip_nodepath = skl_mod.tip_nodepath 
	mech_left_arm.set_tip_node(left_tip.get_path())
	mech_left_arm.set_target_node(get_tree().get_first_node_in_group('player').get_path())
	mech_right_arm.set_tip_node(right_tip.get_path())
	mech_right_arm.set_target_node(get_tree().get_first_node_in_group('player').get_path())
	await get_tree().create_timer(3).timeout
	attack_timer.start()

func _process(_delta):
	left_shoot()
	right_shoot()
	missile_spawn()
	left_arm_death()
	right_arm_death()
	torso_hit_detection()
	torso_death()
	movement()
	move_and_slide()


func movement():
	if global_position.x <= destination:
		velocity.x = 0
func start_moving():
	velocity.x = -200


func left_shoot():
	if not left_has_shot:
		left_has_shot = true
		var bullet = bullet_scene.instantiate()
		bullet.global_position = cannon_spawn_marker.global_position
		bullet.look_at(get_tree().get_first_node_in_group('player').global_position)
		get_tree().current_scene.add_child(bullet)
		left_arm_sound.play()
func _on_left_reset_timer_timeout():
	left_has_shot = false

func right_shoot():
	if not right_has_shot:
		await get_tree().create_timer(0.27).timeout
		right_has_shot = true
		var bullet = small_bullet_scene.instantiate()
		right_arm_sound.play()
		bullet.global_position = gun_spawn_marker.global_position
		bullet.look_at(get_tree().get_first_node_in_group('player').global_position)
		get_tree().current_scene.add_child(bullet)


func _on_right_reset_timer_timeout():
	right_has_shot = false

func missile_spawn():
	var missile_found: int = 0
	for child in get_tree().current_scene.get_children():
		if child is Missile:
			missile_found += 1
	
	if missile_found < 5 and not can_missile:
		can_missile = true
		var missile_instance = missile.instantiate()
		var missile_warning_instance = missile_warning.instantiate()
		get_tree().current_scene.add_child(missile_instance)
		get_tree().current_scene.add_child(missile_warning_instance)
		var spawn_points = level_scene.missile_spawn_markers.get_children()
		var spawn_point = spawn_points[randi() % spawn_points.size()]
		var pos = spawn_point.global_position
		missile_instance.global_position = pos
		missile_warning_instance.global_position = Vector2(1050, pos.y)
		await get_tree().create_timer(1).timeout
		missile_warning_instance.queue_free()
func _on_rocket_reset_timer_timeout():
	can_missile = false

func _on_attack_timer_timeout():
	state_chart.send_event(attack_options[randi_range(0, attack_options.size() - 1)])
	attack_timer.stop()

func _on_left_arm_shoot_state_entered():
	mech_left_arm.enabled = true
	$LeftResetTimer.start()
	left_arm_timer.start()
	await get_tree().create_timer(.1).timeout
	left_has_shot = false
func _on_left_arm_timer_timeout():
	state_chart.send_event('idle_entered')
func _on_left_arm_shoot_state_exited():
	mech_left_arm.enabled = false
	$LeftResetTimer.stop()
	attack_timer.start()


func _on_right_arm_shoot_state_entered():
	mech_right_arm.enabled = true
	$RightResetTimer.start()
	right_arm_timer.start()
	await get_tree().create_timer(.1).timeout
	right_has_shot = false
func _on_right_arm_timer_timeout():
	state_chart.send_event('idle_entered')
func _on_right_arm_shoot_state_exited():
	mech_right_arm.enabled = false
	$RightResetTimer.stop()
	attack_timer.start()


func _on_both_arms_state_entered():
	mech_right_arm.enabled = true
	mech_left_arm.enabled = true
	$RightResetTimer.start()
	$LeftResetTimer.start()
	both_arms_timer.start()
	await get_tree().create_timer(.1).timeout
	right_has_shot = false
	left_has_shot = false
func _on_both_arms_timer_timeout():
	state_chart.send_event('idle_entered')
func _on_both_arms_state_exited():
	mech_right_arm.enabled = false
	mech_left_arm.enabled = false
	$RightResetTimer.stop()
	$LeftResetTimer.stop()
	attack_timer.start()


func _on_fire_breath_state_entered():
	firebreathing = true
	if firebreathing:
		$Node2D/FireBreathSound.play()
		head_sprites.play('fire')
		fire_animations.play(str(fire_options[randi_range(0, fire_options.size() - 1)]))
		firebreath_particle.emitting = true
		await get_tree().create_timer(0.5).timeout
		firebreath_hitbox.set_collision_layer_value(3, true)
	await fire_animations.animation_finished
	head_sprites.play('default')
	head_sprites.rotation = 0
	firebreath_particle.emitting = false
	firebreath_hitbox.set_collision_layer_value(3, false)
	state_chart.send_event('idle_entered')
func _on_fire_breath_state_exited():
	firebreathing = false
	attack_timer.start()




func _on_rocket_launch_state_entered():
	$Node2D/RocketLaunchAnimations.play('arms_up')
	await $Node2D/RocketLaunchAnimations.animation_finished
	can_missile = false
	$RocketLaunchTimer.start()
	$RocketResetTimer.start()
func _on_rocket_launch_timer_timeout():
	state_chart.send_event('idle_entered')
func _on_rocket_launch_state_exited():
	$Node2D/RocketLaunchAnimations.play_backwards('arms_up')
	can_missile = true
	$RocketResetTimer.stop()
	attack_timer.start()

func left_arm_death():
	if left_arm_hitbox.health <= 0:
		left_arm_gone = true
		left_arm_hitbox.set_collision_layer_value(7, false)
		attack_options.erase("left_arm_start")
		if $Node2D/BodyParent/Hips/Torso/LeftArm.visible:
			death_animations.play('left_arm_death')	
		if not right_arm_gone:
			attack_options.erase("both_arms_start")

func right_arm_death():
	if right_arm_hitbox.health <= 0:
		right_arm_gone = true
		right_arm_hitbox.set_collision_layer_value(7, false)
		attack_options.erase("right_arm_start")
		if $Node2D/BodyParent/Hips/Torso/RightArm.visible:
			death_animations.play('right_arm_death')
		if not right_arm_gone:
			attack_options.erase("both_arms_start")

func torso_hit_detection():
	if left_arm_gone and right_arm_gone:
		set_collision_layer_value(7, true)
		$HitMarker.set_collision_layer_value(7, true)
		$HitMarker.set_collision_mask_value(8, true)
func torso_death():
	if health <= 0:
		death_animations.play('torso_death')
		await death_animations.animation_finished
		get_tree().paused = true
		LevelTransitionFinal.change_scene(outro_scene)


func _on_hit_marker_body_entered(body):
	# LEFT
	if body is Fireball:
		$Node2D/HitSound.play()
		var tween = create_tween()
		tween.tween_property($Node2D/BodyParent/Hips/Torso/LeftArm, "modulate", Color.RED, 0.05)
		tween.tween_property($Node2D/BodyParent/Hips/Torso/LeftArm, "modulate", Color.WHITE, 0.05)
func _on_hit_marker_body_entered2(body):
	# RIGHT
	if body is Fireball:
		$Node2D/HitSound.play()
		var tween = create_tween()
		tween.tween_property($Node2D/BodyParent/Hips/Torso/RightArm, "modulate", Color.RED, 0.05)
		tween.tween_property($Node2D/BodyParent/Hips/Torso/RightArm, "modulate", Color.WHITE, 0.05)
func _on_hit_marker_body_entered3(body):
	# TORSO
	if body is Fireball:
		$Node2D/HitSound.play()
		var tween = create_tween()
		tween.tween_property($Node2D/BodyParent/Hips/Torso, "modulate", Color.RED, 0.05)
		tween.tween_property($Node2D/BodyParent/Hips/Torso, "modulate", Color.WHITE, 0.05)
