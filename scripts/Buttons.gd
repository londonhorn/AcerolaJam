extends Button

@onready var hover_sound = $"../../ButtonHover"

func _on_mouse_entered():
	if not disabled:
		hover_sound.play()
