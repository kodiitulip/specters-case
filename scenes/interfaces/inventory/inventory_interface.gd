@static_unload
class_name InventoryInterface
extends MarginContainer

const INVENTORY_SLOT_SCENE: PackedScene = preload("uid://chwlamrudke74")

@export var item_slot_count: int = 6:
	set(value):
		item_slot_count = clampi(value, 0, 6)
@export var temp_item_data: ItemData

var inventory_slots: Array[InventorySlot] = []
static var instance: InventoryInterface

@onready var slots_container: VBoxContainer = %SlotsContainer

func _enter_tree() -> void:
	if instance and instance != self:
		return queue_free()
	instance = self


func _ready() -> void:
	if slots_container.get_child_count() > 0:
		for child: Control in slots_container.get_children():
			child.queue_free()
	for i: int in item_slot_count:
		var slot: InventorySlot = INVENTORY_SLOT_SCENE.instantiate() as InventorySlot
		slots_container.add_child(slot)
		slot.slot_id = i
		slot.on_item_dropped_on.connect(_on_item_droped_on_slot)
		inventory_slots.append(slot)
	pickup_item.call_deferred(temp_item_data)


func _on_item_droped_on_slot(origin_id: int, destination_id: int) -> void:
	var origin_data: ItemData = inventory_slots[origin_id].slot_item
	var destination_data: ItemData = inventory_slots[destination_id].slot_item

	inventory_slots[origin_id].slot_item = destination_data
	inventory_slots[destination_id].slot_item = origin_data


func pickup_item(item: ItemData) -> void:
	for slot: InventorySlot in inventory_slots:
		if slot.slot_item != null:
			continue
		return slot.fill_slot(item)
