extends CanvasLayer

@onready var animation = $AnimationPlayer

func change_scene(target: PackedScene):
	get_tree().paused = true
	animation.play('dissolve')
	await animation.animation_finished
	get_tree().change_scene_to_packed(target)
	animation.play_backwards('dissolve')
	get_tree().paused = false
