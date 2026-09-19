extends Area2D


@export var speed = 800
@export var damage = 1

@onready var axis = Vector2.UP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
# This function should be overridden for each bullet type
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_BaseBullet_body_entered(body: Node2D, target_method = 'enemy_hit') -> void:
	print(body)
	if body.has_method(target_method):
		body.enemy_hit(damage)
		queue_free()

func _on_BaseBullet_area_entered(area: Area2D, target_method = 'enemy_hit') -> void: #appears to be for Stations
	print(area)
	if area.has_method(target_method):
		area.enemy_hit(damage)
		queue_free()
