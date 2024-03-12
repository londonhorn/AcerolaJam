extends Projectile
class_name Fireball

@onready var font = preload("res://assets/Fonts/SpiritsRegular-OEKo.ttf")
@onready var point_popup = preload("res://scenes/score_popup.tscn")

@onready var hit_sound = $Hit

var player = null

func _process(_delta):
	level = Globals.evolution

func _physics_process(_delta):
	velocity = Vector2.RIGHT.rotated(rotation) * 1000
	
	move_and_slide()

func _on_hit_detection_body_entered(body):
	if body is Enemy or body is Projectile and level >= body.level:
		player.points += body.points
		player.health_points_tracker += body.points
		body.health = 0
		hit_sound_play()
		var label = point_popup.instantiate()
		get_tree().current_scene.add_child(label)
		var spawn_points = player.point_markers.get_children()
		var spawn_point = spawn_points[randi() % spawn_points.size()]
		var pos = spawn_point.global_position
		label.text = "+" + str(body.points)
		label.global_position = pos
		await get_tree().create_timer(0.03).timeout
		queue_free()
	elif body is Limb:
		body.health -= 10
		hit_sound_play()
		await get_tree().create_timer(0.03).timeout
		queue_free()
	else:
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func hit_sound_play():
	hit_sound.pitch_scale = randf_range(0.9, 1.1)
	hit_sound.play()
