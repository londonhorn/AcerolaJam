extends ParallaxLayer

var scrolling_speed1 = 450
var scrolling_speed2 = 300

@onready var layer1 = $"../ParallaxLayer"
@onready var layer2 = $"."

func _process(delta):
	layer1.motion_offset.x -= scrolling_speed1 * delta
	layer2.motion_offset.x -= scrolling_speed2 * delta
