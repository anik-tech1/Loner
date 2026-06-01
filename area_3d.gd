extends Area3D

@export var fishing_manager: Node

# The camera will trigger this function when you look at it and press E
func interact() -> void:
	if fishing_manager and fishing_manager.current_state == fishing_manager.FishingState.IDLE:
		fishing_manager.start_fishing()
