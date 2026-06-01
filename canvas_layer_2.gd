extends CanvasLayer

func _ready() -> void:
	# 1. Start a 5-second countdown in the background
	await get_tree().create_timer(5.0).timeout
	
	# 2. Once the timer finishes, hide the UI!
	hide()
