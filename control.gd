extends Control

@export var first_level_path: String = "res://house/node_3d.tscn" # Put your beach scene path here!
@onready var creds = $ColorRect
func _ready() -> void:
	# Make sure the mouse is visible when we are on the main menu!
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(first_level_path)


func _on_credits_pressed() -> void:
	creds.show()


func _on_button_pressed() -> void:
	creds.hide()


func _on_quit_pressed() -> void:
	get_tree().quit()
