class_name PickableInteractableArea2D
extends InteractableArea2D
## PickableInteractableArea2D
##
## This [InteractableArea2D] allows an item with [ItemData] to be picked up and
## sent to the [InventoryInterface]

## The data of this item
@export var item_data: ItemData: set = set_item_data, get = get_item_data
## Tell if the item should desapear after being picked up
@export var infinite: bool = false

func _ready() -> void:
	super._ready()
	assert(item_data != null, "[code]ItemData[/code] must not be null")


## Called the first frame that the interaction starts
func on_interact_started() -> void:
	GlobalSignalBus.send_new_position_to_player(global_position)
	await GlobalSignalBus.player_path_goal_reached
	GlobalInventory.add_item(item_data)
	if not infinite:
		_remove(self)


## Called for every frame that the interaction is happening
func on_interacting() -> void:
	pass


## Called on the last frame that the interaction happens
func on_interact_ended() -> void:
	pass


func _remove(target: Node) -> void:
	GlobalSignalBus.emit_mouse_busy(false)
	target.queue_free()


func set_item_data(value: ItemData) -> void:
	item_data = value


func get_item_data() -> ItemData:
	return item_data
