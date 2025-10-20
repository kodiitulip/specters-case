class_name ItemData
extends Resource

@export var item_name: String
@export var item_icon: Texture2D


func _init(name: String, icon: Texture2D) -> void:
	self.item_name = name
	self.item_icon = icon
