@static_unload
class_name InventoryInterface
extends Control

const INVENTORY_SLOT_SCENE: PackedScene = preload("uid://chwlamrudke74")

@export var item_slot_count: int = 21:
	set(value):
		item_slot_count = clampi(value, 0, 21)

var inventory_slots: Array[InventorySlot] = []
static var instance: InventoryInterface

@onready var inventory: Control = $Inventory
@onready var slots_container: GridContainer = %SlotsContainer
@onready var tooltip: RichTextLabel = %RichTextTooltip
@onready var open_button: TextureButton = $OpenInventoryButton

func _enter_tree() -> void:
	if instance and instance != self:
		return queue_free()
	instance = self


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"escape") and open_button.button_pressed:
		open_button.button_pressed = false
		get_viewport().set_input_as_handled()


func _ready() -> void:
	if slots_container.get_child_count() > 0:
		for child: Control in slots_container.get_children():
			child.queue_free()
	for i: int in item_slot_count:
		var slot: InventorySlot = INVENTORY_SLOT_SCENE.instantiate() as InventorySlot
		slots_container.add_child(slot)
		slot.slot_id = i
		slot.on_item_dropped_on.connect(_on_item_droped_on_slot)
		slot.slot_hover_started.connect(_update_tooltip)
		inventory_slots.append(slot)
	GlobalInventory.inventory_changed.connect(_on_inventory_changed)
	_on_inventory_changed()


func _on_inventory_changed() -> void:
	for item: ItemData in GlobalInventory.items:
		var id: int = GlobalInventory.items.get(item, -1)
		set_item_on_slot(item, id)


func _on_item_droped_on_slot(origin_id: int, destination_id: int) -> void:
	var origin_data: ItemData = inventory_slots[origin_id].slot_item
	var destination_data: ItemData = inventory_slots[destination_id].slot_item
	
	GlobalInventory.items.set(origin_data, destination_id)
	GlobalInventory.items.set(destination_data, origin_id)
	GlobalInventory.items.erase(null)
	
	inventory_slots[origin_id].slot_item = destination_data
	inventory_slots[destination_id].slot_item = origin_data


func set_item_on_slot(item: ItemData, id: int = -1) -> void:
	var slot: InventorySlot
	slot = find_empty_slot() if id == -1 else find_slot_via_slot_id(id)
	if id == -1:
		GlobalInventory.items.set(item, slot.slot_id)
	if slot == null:
		printerr("Inventory Full")
		return
	slot.fill_slot(item)


func _on_open_inventory_button_toggled(toggled_on: bool) -> void:
	inventory.visible = toggled_on
	mouse_filter = Control.MOUSE_FILTER_STOP if toggled_on else Control.MOUSE_FILTER_IGNORE


func find_empty_slot() -> InventorySlot:
	for slot: InventorySlot in inventory_slots:
		if slot.slot_item == null:
			return slot
	return null


func find_slot_via_slot_id(id: int) -> InventorySlot:
	var slot_idx: int = inventory_slots.find_custom(
		func(s: InventorySlot) -> bool: return s.slot_id == id)
	if slot_idx == -1:
		return find_empty_slot()
	return inventory_slots.get(slot_idx)


func _update_tooltip(item: ItemData) -> void:
	var t: Tween = get_tree().create_tween()
	t.tween_property(tooltip, ^"visible_ratio", 0.0, 0.2).from_current()
	await t.finished
	tooltip.clear()
	if item == null:
		return
	var text: String = "%s\n\n%s" % [item.item_name, item.item_description]
	tooltip.add_text(text)
	get_tree().create_tween().tween_property(
		tooltip, ^"visible_ratio", 1.0, 0.005 * text.length()).from(0.0)
