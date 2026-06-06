extends CanvasLayer

# Type the exact file path of your next scene here in the Inspector! (e.g., "res://lake.tscn")
@export var next_scene_path: String 

func _ready() -> void:
	# Hide this entire UI when the level starts
	hide() 

func _process(_delta: float) -> void:
	# 1. Listen for the magic number. 
	# (Change 'Global' and 'sandcastles_built' to match whatever you actually named them!)
	if Global.Lake>=4 and not visible:
		show() # Reveal the "Press F" UI!

func _input(event: InputEvent) -> void:
	# 2. If the UI is currently visible on screen...
	if visible:
		# ...and the player physically presses the 'F' key on their keyboard...
		if event is InputEventKey and event.physical_keycode == KEY_F and event.pressed:
			
			# Ensure you actually typed a path in the Inspector
			if next_scene_path != "":
				SceneTransition.fade_out(3.0)
				await get_tree().create_timer(3.0).timeout
				get_tree().change_scene_to_file(next_scene_path)
				SceneTransition.fade_in(2.0)
			else:
				print("ERROR: You forgot to put a scene path in the Inspector!")
