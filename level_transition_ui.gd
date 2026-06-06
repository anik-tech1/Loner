extends CanvasLayer


@export var next_scene_path: String 

func _ready() -> void:
	
	hide() 

func _process(_delta: float) -> void:
	if Global.Lake>=4 and not visible:
		show()
func _input(event: InputEvent) -> void:

	if visible:
		if event is InputEventKey and event.physical_keycode == KEY_F and event.pressed:
			
			if next_scene_path != "":
				SceneTransition.fade_out(3.0)
				await get_tree().create_timer(3.0).timeout
				get_tree().change_scene_to_file(next_scene_path)
				SceneTransition.fade_in(2.0)
			else:
				print("ERROR: You forgot to put a scene path in the Inspector!")
