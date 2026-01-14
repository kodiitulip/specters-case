extends DialogInteractableItemTraderArea2D

@export var particles: GPUParticles2D

func _ready() -> void:
	super._ready()
	area_entered.connect(_setup)
	GlobalSignalBus.water_off.connect(_on_water_off)
	if GlobalVariables.water_off:
		_on_water_off()


func _setup(_a: Area2D) -> void:
	if GlobalInventory.has_item(item_to_check_for):
		on_interact_started()


func _on_water_off() -> void:
	if particles:
		particles.set_emitting(false)
	set_monitoring(false)
	set_monitorable(false)
	GlobalVariables.water_off = true
