extends Control

var player = null

@onready var sound = $WooshSound
@onready var timer = $DeleteTimer
@onready var cover = $Circle
func _ready():
	var tween = create_tween()
	
	cover.global_position = player.global_position
	
	cover.scale = Vector2.ZERO
	tween.tween_property(cover, "scale", Vector2(4,4), 1.4)
	tween.parallel().tween_property(cover, "modulate", Color.WHITE, 1.4)

func _on_body_entered(body):
	if body is Projectile and not Fireball:
		player.points += body.points
		body.queue_free()

func _on_delete_timer_timeout():
	queue_free()
