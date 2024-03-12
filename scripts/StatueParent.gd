extends Enemy
class_name Boss

@onready var cannon_spawn_marker = $Node2D/BodyParent/Hips/Torso/LeftArm/LeftForearm/LeftArmEnd/Sprite2D/CannonMarker
@onready var gun_spawn_marker = $Node2D/BodyParent/Hips/Torso/RightArm/RightForearm/RightArmEnd/Sprite2D/GunMarker
@onready var skeleton_parent = %BodyParent
@onready var head_sprites = $Node2D/BodyParent/Hips/Torso/Head/HeadSprites
@onready var state_chart = $StateChart
@onready var firebreath_particle = $Node2D/BodyParent/Hips/Torso/Head/HeadSprites/FirebreathEffect
@onready var firebreath_hitbox = $Node2D/BodyParent/Hips/Torso/Head/HeadSprites/FirebreathHitbox
@onready var fire_animations = $Node2D/FireAnimations

@onready var left_tip = $Node2D/BodyParent/Hips/Torso/LeftArm/LeftForearm/LeftArmEnd
@onready var right_tip = $Node2D/BodyParent/Hips/Torso/RightArm/RightForearm/RightArmEnd

@onready var attack_timer = $AttackTimer
@onready var left_arm_timer = $LeftArmTimer
@onready var right_arm_timer = $RightArmTimer
@onready var both_arms_timer = $BothArmsTimer

var bullet_scene = preload("res://scenes/tank_bullet.tscn")
var small_bullet_scene = preload("res://scenes/soldier_bullet.tscn")
var mech_left_arm = load("res://resources/LeftArm.tres")
var mech_right_arm = load("res://resources/RightArm.tres")

var left_has_shot: bool = true
var right_has_shot: bool = true
var firebreathing: bool = false

var destination: int = 1000

var fire_options: Array = [
	"fire_up",
	"fire_down"
]

var attack_options: Array =[
	"left_arm_start",
	"right_arm_start",
	"firebreath_start",
	"both_arms_start"
]

func _ready():
	start_moving()
	var mod_stack = skeleton_parent.get_modification_stack()
	var skl_mod = mod_stack.get_modification(0)
	skl_mod.target_nodepath = skl_mod.target_nodepath
	skl_mod.tip_nodepath = skl_mod.tip_nodepath 
	mech_left_arm.set_tip_node(left_tip.get_path())
	mech_left_arm.set_target_node(get_tree().get_first_node_in_group('player').get_path())
	mech_right_arm.set_tip_node(right_tip.get_path())
	mech_right_arm.set_target_node(get_tree().get_first_node_in_group('player').get_path())
	await get_tree().create_timer(4).timeout
	attack_timer.start()

func _process(_delta):
	left_shoot()
	right_shoot()
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
func _on_left_reset_timer_timeout():
	left_has_shot = false

func right_shoot():
	if not right_has_shot:
		await get_tree().create_timer(0.25).timeout
		right_has_shot = true
		var bullet = small_bullet_scene.instantiate()
		bullet.global_position = gun_spawn_marker.global_position
		bullet.look_at(get_tree().get_first_node_in_group('player').global_position)
		get_tree().current_scene.add_child(bullet)
func _on_right_reset_timer_timeout():
	right_has_shot = false

func _on_attack_timer_timeout():
	state_chart.send_event('right_arm_start')
	#state_chart.send_event(attack_options[randi_range(0, attack_options.size() - 1)])
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


func _on_fire_breath_state_entered():
	firebreathing = true
	if firebreathing:
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


func _on_both_arms_state_entered():
	mech_right_arm.enabled = true
	mech_left_arm.enabled = true
	both_arms_timer.start()
func _on_both_arms_timer_timeout():
	state_chart.send_event('idle_entered')
func _on_both_arms_state_exited():
	mech_right_arm.enabled = false
	mech_left_arm.enabled = false
	attack_timer.start()








