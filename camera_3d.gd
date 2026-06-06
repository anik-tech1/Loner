extends Camera3D

@export var mouse_sensitivity: float = 0.003
@export var max_look_up: float = 80.0
@export var max_look_down: float = -80.0

var pitch: float = 0.0
var yaw: float = 0.0


var can_look: bool = true 

@onready var raycast: RayCast3D = $RayCast3D
@onready var prompt_ui: Label = $"../CanvasLayer/Label" 

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	yaw = rotation.y
	pitch = rotation.x

func _input(event: InputEvent) -> void:
	if can_look and event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(max_look_down), deg_to_rad(max_look_up))
		rotation.y = yaw
		rotation.x = pitch

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	prompt_ui.visible = false 
	
	
	if can_look and raycast.is_colliding():
		var target = raycast.get_collider()
		if target.has_method("interact"):
			prompt_ui.visible = true 
			if Input.is_action_just_pressed("interact"):
				target.interact()
