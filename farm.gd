extends Node3D

# This creates a list in the Inspector where we can drop our fish models!
@export var fish_models: Array[Node3D]

# We use this to remember how many fishes were visible last frame
var last_fish_count: int = -1 

func _ready() -> void:
	# Hide all fishes the moment the game starts
	await get_tree().create_timer(1.0).timeout
	DialogueSystem.start_dialogue([
		"Dad loved it when i went to fish with him ",
		"This is the spot. gonna get 4 fishes",
		])
	for fish in fish_models:
		if fish:
			fish.hide()

func _process(_delta: float) -> void:
	
	if Global.Fishes != last_fish_count:
		last_fish_count = Global.Fishes
		
		
		var max_fishes = clampi(Global.Fishes, 0, fish_models.size())
		
		update_fish_visibility(max_fishes)

func update_fish_visibility(amount_to_show: int) -> void:
	for i in range(fish_models.size()):
		var current_fish = fish_models[i]
		
		if current_fish:
			if i < amount_to_show:
				current_fish.show()
			else:
				current_fish.hide()
