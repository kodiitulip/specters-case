class_name DialogInteractableItemGiverArea2D
extends DialogInteractableArea2D

const LOOSE_ITEM: PackedScene = preload("uid://bngnnh8t3orrh")

const GLOBAL_INPUT_NAMES: PackedStringArray = [
	"GlobalVariables", "GlobalInventory"]
var GLOBAL_INPUTS: Array = [GlobalVariables, GlobalInventory]

enum ActivationEvent {
	ON_READY,
	ON_INTERACT_STARTED,
}

@export var item_to_drop: ItemData
@export var success_dialog: DialogicTimeline
@export var fail_dialog: DialogicTimeline
@export var activation_event: ActivationEvent
@export var free_when_drop: bool = false

@export_group("Expressions")
## Boolean expression to check if the actor should drop an item.
## It has access to [code]GlobalVariables[/code], [code]GlobalInventory[/code]
## and [code]self[/code]
@export_custom(PROPERTY_HINT_EXPRESSION, "") var should_drop_expression: String = \
	"true"
## Boolean expression to check if the actor should call the fail dialog.
## It has access to [code]GlobalVariables[/code], [code]GlobalInventory[/code]
## and [code]self[/code]
@export_custom(PROPERTY_HINT_EXPRESSION, "") var fail_dialog_expression: String = \
	"false"

func _ready() -> void:
	super._ready()
	if activation_event == ActivationEvent.ON_READY:
		_handle_fail_dialog()
		_handle_dropping_item()


func on_interact_started() -> void:
	await super.on_interact_started()
	if dialog:
		await Dialogic.timeline_ended
	if activation_event == ActivationEvent.ON_INTERACT_STARTED:
		_handle_fail_dialog()
		_handle_dropping_item()


func _handle_fail_dialog() -> void:
	var expr: Expression = Expression.new()
	expr.parse(fail_dialog_expression, GLOBAL_INPUT_NAMES)
	var should_play: Variant = expr.execute(GLOBAL_INPUTS, self)
	var has_failed: bool = expr.has_execute_failed()
	assert(not has_failed)
	if should_play and fail_dialog != null:
		Dialogic.start(fail_dialog)


func _handle_dropping_item() -> void:
	var expr: Expression = Expression.new()
	expr.parse(should_drop_expression, GLOBAL_INPUT_NAMES)
	var should_drop: Variant = expr.execute(GLOBAL_INPUTS, self)
	var has_failed: bool = expr.has_execute_failed()
	assert(not has_failed)
	if not should_drop:
		return
	
	var pos: Vector2 = (interact_position_marker.global_position
		if interact_position_marker else global_position)
	var inst: PickableInteractableArea2D = LOOSE_ITEM.instantiate()
	inst.global_position = pos
	inst.set_item_data(item_to_drop)
	get_parent().add_child.call_deferred(inst)
	if success_dialog:
		Dialogic.start(success_dialog)
		await Dialogic.timeline_ended
	if free_when_drop:
		queue_free.call_deferred()
