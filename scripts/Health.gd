extends TextureProgressBar

func _on_character_base_health_changed(max_health, current_health):
	max_value = max_health
	value = current_health
