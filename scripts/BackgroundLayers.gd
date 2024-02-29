extends ParallaxLayer

var scrolling_speed = 600

func _process(delta):
	motion_offset.x -= scrolling_speed * delta
