extends Node2D

var stations_cleared = false

func _ready() -> void:
	
	pass

func _process(_delta: float) -> void:
	if !stations_cleared and len(get_tree().get_nodes_in_group("station")) == 0:
		stations_cleared = true
