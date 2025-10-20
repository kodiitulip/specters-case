extends Node2D

# Defining some variables
@onready var player = $Player # Player object

# function that identifies the click position and moves the player to it
func _input(event: InputEvent) -> void:
	
	# Boolean variable for click
	var click: bool = (
	event is InputEventMouseButton
	and event.button_index == MOUSE_BUTTON_LEFT 
	and event.is_pressed()
)
	# Checking the click
	if (click):
		var move_pos = get_global_mouse_position() # Getting the click position
		player.setTarget(move_pos) # Moving the player
