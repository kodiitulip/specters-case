extends CharacterBody2D

@export var speed: float = 150.0
var _mouse_busy: bool = false: set = _set_mouse_busy

func _ready() -> void:
	GlobalSignalBus.mouse_busy.connect(_set_mouse_busy)

func _physics_process(delta: float) -> void:
	if _mouse_busy:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction := Vector2.ZERO

	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("d"):
		direction.x += 1
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("a"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("s"):
		direction.y += 1
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("w"):
		direction.y -= 1

	velocity = direction.normalized() * speed
	move_and_slide()

func _set_mouse_busy(value: bool) -> void:
	_mouse_busy = value
