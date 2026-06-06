extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.modulate.a = 0.0 
	color_rect.hide()


func fade_out(duration: float = 2.0) -> void:
	color_rect.show()
	var tween = create_tween()

	tween.tween_property(color_rect, "modulate:a", 1.0, duration)
	await tween.finished


func fade_in(duration: float = 2.0) -> void:
	var tween = create_tween()
	
	tween.tween_property(color_rect, "modulate:a", 0.0, duration)
	await tween.finished
	color_rect.hide()
