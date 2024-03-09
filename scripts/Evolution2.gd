extends ProgressBar

@onready var vbox = $".."

func _process(_delta):
	value = Globals.character_speed + Globals.character_health
	hide_all()

func hide_all():
	if value <= 849 or value >= 1084:
		vbox.visible = false
	elif value >= 849 or value <= 1084:
		vbox.visible = true
