extends Node

var total_points: int
var player_points: int
var character_size: Vector2 = Vector2(1, 1)
var character_health: int = 100
var can_fireball: bool = false
var can_shield: bool = false
var evolution: int = 0
var current_wave: int = 0
var current_wave_increment: int = 0
