extends Button

@onready var pop_sound = $PopSound
@onready var animations = $AnimationPlayer
@onready var click_sound = $ButtonClick
@onready var wait_timer = $WaitTimer

@onready var level = preload("res://scenes/level.tscn")
@onready var particle_scene = preload("res://scenes/particle_scene.tscn")

func _process(_delta):
	if Input.is_action_just_pressed('click'):
		wait_timer.stop()
		wait_timer.wait_time = 0.5
		wait_timer.start()

func _ready():
	await wait_timer.timeout
	animation()

func animation():
	var tween = create_tween()
	tween.set_trans(tween.TRANS_ELASTIC)
	tween.tween_property(self, "modulate", Color.WHITE, 1.2)
	tween.parallel().tween_property(self, "scale", Vector2(1,1), 1.3)
	await get_tree().create_timer(.7).timeout
	pop_sound.play()
	await tween.finished
	animations.play('wiggle')

func _on_pressed():
	click_sound.play()
	await click_sound.finished
	LevelTransition.change_scene(particle_scene)

func _on_mouse_entered():
	$ButtonHover.play()
