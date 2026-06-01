extends Area3D

@export var puzzle_manager: Node3D
@export var tier_id: int # Set to 0 for Base, 1 for Mid, 2 for Top

# This built-in function detects whenever the mouse interacts with this specific Area3D
func _input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	
	# Check if the interaction was a Left Mouse Button click, and that it was just pressed
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		# Tell the manager to cycle this specific tier!
		if puzzle_manager:
			puzzle_manager.cycle_tier(tier_id)
