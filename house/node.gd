extends Node

@export_group("Event Settings")
@export var prompt_ui: Label
@export var hand_phone: Node3D
@export var ring_sound: AudioStreamPlayer
@export var wait_time: float = 5.0

var is_ringing: bool = false
var has_been_answered: bool = false

func _ready() -> void:
	if hand_phone: hand_phone.hide()
		
	await get_tree().create_timer(wait_time).timeout
	
	start_ringing()

func start_ringing() -> void:
	if has_been_answered: return 
	is_ringing = true
	
	if ring_sound: ring_sound.play()
	if prompt_ui:
		prompt_ui.text = "Press E to Answer Phone"
		prompt_ui.visible = true

func _process(delta: float) -> void:
	if is_ringing and Input.is_action_just_pressed("interact"):
		answer_phone()

func answer_phone() -> void:
	is_ringing = false
	has_been_answered = true
	
	if prompt_ui: prompt_ui.visible = false
	if ring_sound: ring_sound.stop()
	if hand_phone: hand_phone.show()
	
	DialogueSystem.start_dialogue([
		"Hello?", 
		"Colleague:Bro this vacation I am hosting a party wanna come?", 
		"What will be in it",
		"Colleague:Booze , Girls , anything anyone want",
		"Nah i have some other plans",
		"Colleague:oh come on! you dont even have friends other than us",
		"you won't understand."
	])
	

	await DialogueSystem.dialogue_finished
	

	SceneTransition.fade_out(3.0)
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://beach.tscn")
	SceneTransition.fade_in(2.0)
