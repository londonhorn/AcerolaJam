extends Label

@onready var pop_sound = $PopSound
@onready var animations = $AnimationPlayer
@onready var wait_timer = $WaitTimer

func _process(_delta):
	if Input.is_action_just_pressed('click'):
		wait_timer.stop()
		wait_timer.wait_time = 0.1
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
