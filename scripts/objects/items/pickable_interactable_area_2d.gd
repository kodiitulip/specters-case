class_name PickableInteractableArea2D
extends InteractableArea2D
## PickableInteractableArea2D
##
## This [InteractableArea2D] allows an item with [ItemData] to be picked up and
## sent to the [InventoryInterface]

## The data of this item
@export var item_data: ItemData
## Tell if the item should desapear after being picked up
@export var finite: bool = true
## The Node this area should [code]queue_free()[/code] in case of being finite.
## If [code]null[/code], deafults to [code]queue_free()[/code] the area itself
@export var free_target: Node = null

func _ready() -> void:
	assert(item_data != null, "[code]ItemData[/code] must not be null")


## Called the first frame that the interaction starts
func on_interact_started() -> void:
	InventoryInterface.instance.pickup_item(item_data)
	if not finite:
		return
	if free_target != null:
		return free_target.queue_free()
	queue_free()


## Called for every frame that the interaction is happening
func on_interacting() -> void:
	pass


## Called on the last frame that the interaction happens
func on_interact_ended() -> void:
	pass
