extends DialogInteractableArea2D

const LOOSE_ITEM: PackedScene = preload("uid://bngnnh8t3orrh")

@export var item_to_drop: ItemData
@export var player_lost_dialog: DialogicTimeline

func _ready() -> void:
	if not GlobalVariables.front_desk_ghost_defeated:
		super._ready()
		if GlobalVariables.started_front_desk_battle:
			Dialogic.start(player_lost_dialog)
		return
	
	var pos: Vector2 = (interact_position_marker.global_position
		if interact_position_marker else global_position)
	var inst: PickableInteractableArea2D = LOOSE_ITEM.instantiate()
	inst.set_global_position.call_deferred(pos)
	inst.set_item_data(item_to_drop)
	get_parent().add_child(inst)
	queue_free()


func on_interact_started() -> void:
	GlobalVariables.started_front_desk_battle = true
	super.on_interact_started()
