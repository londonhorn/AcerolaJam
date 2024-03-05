extends Label

@onready var progress_bar = $".."

func _process(_delta):
		text = str((progress_bar.value / progress_bar.max_value) * 100) + "%"
