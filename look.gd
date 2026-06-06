extends Camera3D

@export var mouse_sensitivity: float = 0.003
@export var first_level_path: String = "res://Start.tscn"
@onready var label : Label = $"../SceneTransition/Label"

@export_group("Vertical Limits")
@export var max_look_up: float = 80.0
@export var max_look_down: float = -80.0

@export_group("Horizontal Limits")
@export var max_look_left: float = 90.0
@export var max_look_right: float = -90.0

var pitch: float = 0.0
var yaw: float = 0.0
var start_yaw: float = 0.0


var can_look: bool = false 

@onready var mesh = $"../Untitled"

func _ready() -> void:
	yaw = rotation.y
	pitch = rotation.x
	start_yaw = rotation.y
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	await get_tree().create_timer(1.0).timeout
	DialogueSystem.start_dialogue([
		"This is the place where mom and dad met huh?",
		"before the accident dad told me about this place",
		"but never got the time to get here",
		"looking at this, I... I... miss them",
		"when they left i wanted to cry but couldn,t",
		"all the 'men dont cry','be a man' in my whole life",
		"my tears wont even come out"
		])
	await DialogueSystem.dialogue_finished
	
	SceneTransition.fade_out(3.0)
	
	await get_tree().create_timer(3.0).timeout
	mesh.show()
	SceneTransition.fade_in(1.0)
	DialogueSystem.start_dialogue([
		"???:then maybe you need to woman up and cry as much as you need",
		"Woah! where did ya come from?",
		"???:i was just passing by and heard you tell a story that i relate",
		"whats your story then",
		"???:Well dad left when i was 5 and mom died 2 yrs ago due to cancer",
		"damn that must be hard",
		"???: you know it very well. By the way i am sam short for samantha",
		"what? me too",
		"sam: samantha?",
		"very funny"
		])
	await DialogueSystem.dialogue_finished
	SceneTransition.fade_out(5.0)
	await get_tree().create_timer(3.0).timeout
	label.show()
	await get_tree().create_timer(5.0).timeout
	
	get_tree().change_scene_to_file(first_level_path)
	SceneTransition.fade_in(1.0)
	
	
	can_look = true

func _input(event: InputEvent) -> void:
	
	if not can_look:
		return
		
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		
		pitch = clamp(pitch, deg_to_rad(max_look_down), deg_to_rad(max_look_up))
		yaw = clamp(yaw, start_yaw + deg_to_rad(max_look_right), start_yaw + deg_to_rad(max_look_left))
		
		rotation.y = yaw
		rotation.x = pitch

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
