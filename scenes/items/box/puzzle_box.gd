extends OverlayInteractableArea2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func on_interact_started() -> void:
	assert(overlay_scene != null, "[code]overlay_scene[/code] must not be null")
	GlobalSignalBus.send_new_position_to_player(global_position)
	await GlobalSignalBus.player_path_goal_reached
	var overlay: Node = overlay_scene.instantiate()
	sprite.play(&"default")
	await sprite.animation_finished
	OverlayLayer.change_overlay_to(overlay)
	OverlayLayer.overlay_unloaded.connect(_on_overlay_unloaded)


func _on_overlay_unloaded() -> void:
	queue_free()
