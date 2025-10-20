extends CharacterBody2D

# Defining some player variables
var speed: float = 150.0
var target_pos: Vector2 # Target position to move

func _ready() -> void:
	target_pos = global_position

# Function that sets the target position
func setTarget(pos: Vector2) -> void:
	target_pos = pos
	
# Making player move
func _physics_process(delta: float) -> void:
	global_position = global_position.move_toward(target_pos, speed * delta)
	if (target_pos):
		var direction: Vector2 = (target_pos - global_position)
		if direction.length() > 1:
			velocity = direction.normalized() * speed
		else:
			velocity = Vector2.ZERO
		move_and_slide()
