extends ProgressBar

@onready var vbox = $".."

func _process(_delta):
	value = Globals.character_size.x + Globals.character_size.y + (float(Globals.character_health) / 100)
	hide_all()

func hide_all():
	if value <= 4.59 or value >= 7.49:
		vbox.visible = false
	elif value >= 4.59 or value <= 7.49:
		vbox.visible = true
