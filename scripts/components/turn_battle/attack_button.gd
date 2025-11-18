class_name BattleActionButton
extends Button

signal action_pressed(action: BattleAction)

@export var action: BattleAction

func _ready() -> void:
	pressed.connect(_on_action_pressed)
	disabled = action == null


func _on_action_pressed() -> void:
	action_pressed.emit(action)


func reevaluate() -> void:
	disabled = should_disable()


func should_disable() -> bool:
	return action == null or (action.item_requirements_enable 
			and not GlobalInventory.has_item(action.required_item))
