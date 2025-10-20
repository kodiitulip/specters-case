extends CharacterBody2D

# Defining some player variables
@export var speed: float = 150.0
var target_pos: Vector2 # Target position to move

func _ready() -> void:
	target_pos = global_position

# Function that sets the target position
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"left_mouse_button"):
		target_pos = get_global_mouse_position()
	
# Making player move
func _physics_process(delta: float) -> void:
	if not target_pos:
		return
	global_position = global_position.move_toward(target_pos, speed * delta)
	var direction: Vector2 = (target_pos - global_position)
	if direction.length() > 1:
		velocity = direction.normalized() * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
