extends Node2D

@onready var level_container = $LevelContainer
var current_level

signal level_clear

func _ready() -> void:
	change_level()

var stations_cleared = false
func _process(delta: float) -> void:
	if !stations_cleared and len(get_tree().get_nodes_in_group("station")) == 0:
		stations_cleared = true
		print("Stations cleared!")

func change_level() -> void:
	if current_level:
		current_level.queue_free()
	current_level = load("res://DemoField/demo_field.tscn")
	level_container.add_child(current_level)
