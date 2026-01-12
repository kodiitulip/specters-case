extends PickableInteractableArea2D

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	super._ready()
	if item_data and item_data.item_icon:
		sprite.set_texture(item_data.item_icon)
