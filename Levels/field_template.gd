extends Node2D

var spawn_positon: Vector2 = Vector2.ZERO
@export var bonus_points: int = 40

func _ready() -> void:
	spawn_positon = $"Spawn Position".global_position

func _process(delta: float) -> void:
	Globals.field_time_left = $BadTimer.time_left
