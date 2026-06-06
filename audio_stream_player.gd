extends AudioStreamPlayer

# How many seconds the fade-in should take
@export var fade_duration: float = 3.0 

# The final volume you want the music to reach (0 is default max volume)
@export var target_volume_db: float = 0.0 

func _ready() -> void:
	# 1. Force the volume to be completely silent before it even starts playing
	volume_db = -60.0 
	
	# 2. Start playing the track (it will be silent!)
	play()
	
	# 3. Create a Tween to smoothly glide the volume up
	var tween = create_tween()
	
	# Transition the volume_db property to our target volume over the duration
	tween.tween_property(self, "volume_db", target_volume_db, fade_duration).set_trans(Tween.TRANS_SINE)
