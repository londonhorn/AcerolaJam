extends ParallaxBackground

var scrolling_speed1 = 840
var scrolling_speed2 = 300
var scrolling_speed3 = 800

@onready var layer1 = $ParallaxLayer
@onready var layer2 = $ParallaxLayer2
@onready var layer3 = $ParallaxLayer3


func _process(delta):
	layer1.motion_offset.x -= scrolling_speed1 * delta
	layer2.motion_offset.x -= scrolling_speed2 * delta
	layer3.motion_offset.x -= scrolling_speed3 * delta

