extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	# Start the game with the screen perfectly clear
	color_rect.modulate.a = 0.0 
	color_rect.hide()

# Fades the screen TO black
func fade_out(duration: float = 2.0) -> void:
	color_rect.show()
	var tween = create_tween()
	# Smoothly transition the Alpha (a) channel to 1.0 (Solid)
	tween.tween_property(color_rect, "modulate:a", 1.0, duration)
	await tween.finished

# Fades the screen FROM black back to the game
func fade_in(duration: float = 2.0) -> void:
	var tween = create_tween()
	# Smoothly transition the Alpha (a) channel to 0.0 (Invisible)
	tween.tween_property(color_rect, "modulate:a", 0.0, duration)
	await tween.finished
	color_rect.hide()
