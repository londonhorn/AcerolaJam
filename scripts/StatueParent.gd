extends Enemy
class_name Boss

var bullet_scene = preload("res://scenes/tank_bullet.tscn")

var mech_left_arm = load("res://resources/LeftArm.tres")

var has_shot: bool = false

@onready var cannon_spawn_marker = $Node2D/BodyParent/Hips/Torso/LeftArm/LeftForearm/LeftArmEnd/Sprite2D/CannonMarker
@onready var skeleton_parent = %BodyParent
func _ready():
	var mod_stack = skeleton_parent.get_modification_stack()
	var skl_mod = mod_stack.get_modification(0)
	skl_mod.target_nodepath = skl_mod.target_nodepath
	skl_mod.tip_nodepath = skl_mod.tip_nodepath 
	mech_left_arm.set_target_node(get_tree().get_first_node_in_group('player').get_path())
	#pass

func _process(_delta):
	if not has_shot:
		shoot()
	#pass

func shoot():
	await get_tree().create_timer(.02).timeout
	has_shot = true
	mech_left_arm.enabled = true
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = cannon_spawn_marker.global_position
	bullet.look_at(get_tree().get_first_node_in_group('player').global_position)
	await get_tree().create_timer(.05).timeout
	has_shot = false

