extends ParallaxBackground

func _process(delta):
	motion_offset.x -= scrolling_speed * delta
