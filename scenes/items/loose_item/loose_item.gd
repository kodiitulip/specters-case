extends PickableInteractableArea2D

@export var success_dialog: DialogicTimeline

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	super._ready()
	if item_data and item_data.item_icon:
		sprite.set_texture(item_data.item_icon)


func on_interact_started() -> void:
	super.on_interact_started()
	if success_dialog:
		Dialogic.VAR.set_variable("puzzles.item_name", item_data.item_name)
		Dialogic.VAR.set_variable("puzzles.item_icon", item_data.item_icon.resource_path)
		Dialogic.start(success_dialog)
