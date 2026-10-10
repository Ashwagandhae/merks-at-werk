extends CharacterBody2D

const SPEED = 200
const MAX_SPEED = 300
const VELOCITY_DELTA = 50
const ACCELERATION = 7200
const FRICTION = 5400

# Weapon Stats

@export var shot_pattern : ShotPattern
@export var back_shot_pattern : ShotPattern
@export var bullet_scene : PackedScene

@onready var input_axis = Vector2.ZERO
@onready var axis = Vector2.UP
@onready var SpawnPos = $SpawnPos
@onready var SpawnPosBehind = $SpawnPosBehind
@onready var World = get_parent().get_node("World")
@onready var current_acceleration = 0

var shooting_enabled = true

@export var health: int = 5

func _physics_process(delta: float) -> void:
	
	Globals.player_position = global_position
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	move_default(delta)
	rotate_default(delta)
	move_and_slide()
	
	if global_position.x >= World.bounds_positive.x:
		global_position.x = World.bounds_negative.x
	elif global_position.x <= World.bounds_negative.x:
		global_position.x = World.bounds_positive.x

	if global_position.y <= World.bounds_positive.y:
		global_position.y = World.bounds_negative.y
	elif global_position.y >= World.bounds_negative.y:
		global_position.y = World.bounds_positive.y
	Globals.player_position = global_position
	
	"""
	
	if global_position.x > World.map_size.x/2:
		global_position.x -= World.map_size.x
	elif global_position.x < -World.map_size.x/2:
		global_position.x += World.map_size.x

	if global_position.y > World.map_size.y/2:
		global_position.y -= World.map_size.y
	elif global_position.y < -World.map_size.y/2:
		global_position.y += World.map_size.y
	Globals.player_position = global_position
	"""
	
func move_default(delta: float):
	#print(snapped(global_position, Vector2(1,1)))
	input_axis = get_input_axis()
	if input_axis != Vector2.ZERO:
		current_acceleration = ACCELERATION
		axis = input_axis
	if snap_to_tenths(axis) == -snap_to_tenths(velocity.normalized()):
		current_acceleration = ACCELERATION - FRICTION
	var accel = axis * current_acceleration * delta
	velocity += accel
	velocity = velocity.limit_length(MAX_SPEED)

func rotate_default(_delta: float):
	rotation_degrees = rad_to_deg(atan2(axis.y, axis.x))


func get_input_axis():
	return Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Up", "Down"))


func apply_friction(amount: float):
	if velocity.length() > amount:
		velocity -= amount * velocity.normalized()
	else:
		velocity = Vector2.ZERO


func _process(_delta: float):
	if Input.is_action_pressed("Shoot") and shooting_enabled:
		shoot()


func _on_ShootSpeed_timeout():
	shooting_enabled = true


func shoot():
	print("player: axis.angle() = ", rad_to_deg(axis.angle()))
	shot_pattern.fire(SpawnPos.global_position, rad_to_deg(axis.angle()), get_tree().current_scene)
	back_shot_pattern.fire(SpawnPosBehind.global_position, rad_to_deg((-axis).angle()), get_tree().current_scene)
	$ShootSpeed.start(shot_pattern.firing_rate)
	shooting_enabled = false


func player_hit(damage):
	health -= damage
	if health <= 0:
		explode()


func explode():
	# Play animation
	queue_free()


func snap_to_tenths(vector: Vector2):
	# Rounds components of vector to tenths place
	return vector.snapped(Vector2(0.1,0.1))
