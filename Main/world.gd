extends Node

var levels : Array[String] = [
	"res://Levels/level1.tscn",
	"res://Levels/level2.tscn",
	"res://Levels/level3.tscn",
	"res://Levels/level4.tscn"
]

var current_level_index : int = 0
var current_level
var current_field
var map_size : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_field(0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_level(index : int):
	if 0 <= index and index < levels.size():
		if current_level:
			current_level.queue_free()
		current_level = load(levels[index])
		add_child(current_level)
func load_field(index : int):
	if 0 <= index and index < INF:
		if current_field:
			current_field.queue_free()
		current_field = load("res://Levels/demo_field.tscn").instantiate()
		add_child(current_field)
		map_size = current_field.map_size
		print(current_field)
		print("demo_field loaded")
