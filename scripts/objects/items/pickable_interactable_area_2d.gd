class_name PickableInteractableArea2D
extends InteractableArea2D

@export var item_data: ItemData
@export var finite: bool = true
@export var free_target: Node

func on_interact_started() -> void:
	InventoryInterface.instance.pickup_item(item_data)
	if not finite:
		return
	if free_target != null:
		return free_target.queue_free()
	queue_free()


func on_interacting() -> void:
	pass


func on_interact_ended() -> void:
	pass
