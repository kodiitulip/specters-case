extends DialogInteractableItemTraderArea2D

func _handle_dropping_item() -> void:
	var expr: Expression = Expression.new()
	expr.parse(should_drop_expression, GLOBAL_INPUT_NAMES)
	var should_drop: Variant = expr.execute(GLOBAL_INPUTS, self)
	var has_failed: bool = expr.has_execute_failed()
	assert(not has_failed)
	if not should_drop:
		return
	
	if success_dialog:
		Dialogic.start(success_dialog)
		await Dialogic.timeline_ended
	GlobalVariables.elevator = true
	SceneTransitionManager.transition_to("uid://crpk730fq825d")
