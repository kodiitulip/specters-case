class_name SceneTransition
extends CanvasLayer
## Scene Transition Manager
##
## It has functions that help with transitioning between scenes with a little
## animation to hide the ugliness.

enum TransitionState {
	IN,  ## [code]IN[/code] state indicates we are transitioning INto the loading screen
	OUT, ## [code]OUT[/code] state indicates we are transitioning OUT of the loading screen
}

## The UUID of the scene we are transitioning to
var scene_uuid_to_transition: String
## Current transition_state
var transition_state: TransitionState = TransitionState.OUT
var _transitioning: bool = false

@onready var _progress_bar: ProgressBar = %ProgressBar

func _process(_delta: float) -> void:
	# Do nothing if not transitioning
	if not _transitioning or not scene_uuid_to_transition:
		return
	# ResourceLoader's threaded loading requires an Array to get status
	var progress: Array = []
	var load_status: ResourceLoader.ThreadLoadStatus = ResourceLoader\
		.load_threaded_get_status(scene_uuid_to_transition, progress)
	_progress_bar.value = progress[0]
	# If loaded grab the loaded PackedScene and finish the transition
	if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene: Resource = ResourceLoader.load_threaded_get(
			scene_uuid_to_transition)
		_finish_transition(new_scene)


# Function called when the scene has loaded and we can transition OUT of
# the loading screen.
func _finish_transition(loaded_scene: Resource) -> void:
	if not loaded_scene:
		return printerr("Scene has not properly loaded!")
	if loaded_scene is PackedScene:
		# use godots functions to change the current scene to a PackedScene
		# resource.
		get_tree().change_scene_to_packed(loaded_scene as PackedScene)
	# Reset variables/flags
	_transitioning = false
	transition_state = TransitionState.OUT
	scene_uuid_to_transition = ""


# Function called from the animation player when the transition INto the loading
# screen has finished.
func _request_load() -> void:
	# Small check to avoid calling this function twice on the animation
	if transition_state == TransitionState.OUT:
		return
	if get_tree().current_scene:
		# Use godots tree unloading to unload the current scene
		get_tree().unload_current_scene()
	# Use the [ResourceLoader] to load the requested scene
	ResourceLoader.load_threaded_request(scene_uuid_to_transition)
	# set transitioning flag to true
	_transitioning = true


## Function that initiates the transition of a scene.
## It requests the UUID (or path) of the scene file.
func transition_to(scene_uuid: String) -> void:
	scene_uuid_to_transition = scene_uuid
	transition_state = TransitionState.IN
