extends Area3D

@export var puzzle_manager: Node3D
@export var tier_id: int 


func _input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		if puzzle_manager:
			puzzle_manager.cycle_tier(tier_id)
