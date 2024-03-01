extends ProgressBar

@onready var player = $"../../CharacterBase"


func _ready():
	update()

func update():
	value = player.current_health * 100 / player.max_health
