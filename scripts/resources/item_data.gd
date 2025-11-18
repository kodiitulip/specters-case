@tool
class_name ItemData
extends Resource

@export var item_name: String:
	set(v):
		item_name = v
		resource_name = item_name
@export_multiline var item_description: String
@export var item_icon: Texture2D


func _init() -> void:
	resource_name = item_name
