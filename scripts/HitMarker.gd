extends Area2D

func _on_area_entered(area):
	$"../../../../../../../HitSound".play()
	var tween = create_tween()
