extends CanvasLayer

# --- NEW: Declare the custom signal! ---
signal dialogue_finished 

@export_group("Dialogue Settings")
@export var text_speed: float = 0.04
@export var text_label: RichTextLabel
@export var voice_blip: AudioStreamPlayer

var is_typing: bool = false
var dialogue_queue: Array[String] = [] 

func _ready() -> void:
	hide() 

func start_dialogue(lines: Array[String]) -> void:
	if lines.is_empty():
		return
		
	dialogue_queue = lines.duplicate() 
	show()
	play_next_line()

func play_next_line() -> void:
	if dialogue_queue.is_empty():
		hide()
		# --- NEW: Shout to the rest of the game that we are done! ---
		dialogue_finished.emit() 
		return
		
	var current_text = dialogue_queue.pop_front()
	
	text_label.text = current_text
	text_label.visible_characters = 0
	is_typing = true
	
	for i in range(text_label.get_total_character_count()):
		if not is_typing: 
			break 
			
		text_label.visible_characters += 1
		
		if voice_blip:
			voice_blip.pitch_scale = randf_range(0.9, 1.1)
			voice_blip.play()
			
		await get_tree().create_timer(text_speed).timeout

	text_label.visible_characters = -1 
	is_typing = false

func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("interact"):
		if is_typing:
			text_label.visible_characters = -1
			is_typing = false
		else:
			play_next_line()
