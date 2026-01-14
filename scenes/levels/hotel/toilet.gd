extends DialogInteractableItemGiverArea2D

const PUZZLE_BOX: PackedScene = preload("uid://doo76dl4rk7ln")


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
	var inst: OverlayInteractableArea2D = PUZZLE_BOX.instantiate()
	inst.global_position = pos
	get_parent().add_child.call_deferred(inst)
	if success_dialog:
		Dialogic.start(success_dialog)
		await Dialogic.timeline_ended
	if free_when_drop:
		queue_free.call_deferred()
	GlobalVariables.toilet_interacted = true
