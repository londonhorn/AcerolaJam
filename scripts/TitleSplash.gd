extends Sprite2D

@onready var pop_sound = $PopSound
@onready var animations = $AnimationPlayer

func _ready():
	animation()

func animation():
	var tween = create_tween()
	tween.set_trans(tween.TRANS_ELASTIC)
	tween.tween_property(self, "modulate", Color.WHITE, 1.2)
	tween.parallel().tween_property(self, "scale", Vector2(2,2), 1.3)
	await get_tree().create_timer(.7).timeout
	pop_sound.play()
	await tween.finished
	animations.play('wiggle')
