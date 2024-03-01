extends Enemy

func _ready():
	velocity.x = randi_range(-500, -800)

func _physics_process(_delta):
	
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
