class_name BaseField
extends Node2D

@export var spawn_positon : Vector2 = Vector2.ZERO
@export var bonus_points  : int = 40
@export var timer_enabled : bool = false
@export var field_timer   : Node
@export var spawn_timer   : Node
@export var missile_scene : PackedScene

func _ready():
	Globals.player_position = spawn_positon
	if timer_enabled:
		print("start field timer")
		field_timer.start()
	print("start spawn timer")
	spawn_timer.start()

func _process(delta: float) -> void:
	if timer_enabled:
		Globals.field_time_left = field_timer.time_left
	


func _on_SpawnTimer_timeout() -> void:
	var missile = missile_scene.instantiate()
	var screen_size = DisplayServer.screen_get_size()
	var edge_pos : Vector2 = screen_size * 3 / 2
	var location = randi() % 4
	match location:
		0:
			edge_pos.x = randi_range(-edge_pos.x, edge_pos.x)
			edge_pos.y = -edge_pos.y #top edge
		1:
			edge_pos.x = randi_range(-edge_pos.x, edge_pos.x)
			edge_pos.y = edge_pos.y #bottom edge
		2:
			edge_pos.x = -edge_pos.x #left edge
			edge_pos.y = randi_range(-edge_pos.y, edge_pos.y)
		3:
			edge_pos.x = edge_pos.x #right edge
			edge_pos.y = randi_range(-edge_pos.y, edge_pos.y)
	missile.global_position = get_viewport().get_camera_2d().global_position + edge_pos
	missile.axis = (Globals.player_position - missile.global_position).normalized()
	missile.look_at(Globals.player_position)
	add_child(missile)
	print("Booyakasha! gp = ", missile.global_position, ", edge = ", edge_pos)
	spawn_timer.start()
