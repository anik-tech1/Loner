extends Node3D

@export var prompt_ui: Label
@onready var sit_position: Marker3D =$Sketchfab_Scene/Sketchfab_model/root/GLTF_SceneRootNode/Bench_01_0/Object_4/SitPosition
@onready var stand_position: Marker3D = $Sketchfab_Scene/Sketchfab_model/root/GLTF_SceneRootNode/Bench_01_0/Object_4/StandPosition

var is_player_near: bool = false
var is_seated: bool = false


var player_node: CharacterBody3D = null 

func _process(_delta: float) -> void:
	if is_player_near and Input.is_action_just_pressed("interact"):
		if is_seated:
			stand_up()
		else:
			sit_down()

func sit_down() -> void:
	is_seated = true
	if prompt_ui: prompt_ui.text = "Press E to Stand Up"
	

	if player_node:
		player_node.set_physics_process(false) 
		

		var tween = create_tween()
		tween.tween_property(player_node, "global_position", sit_position.global_position, 1.0).set_trans(Tween.TRANS_SINE)

func stand_up() -> void:
	is_seated = false
	if prompt_ui: prompt_ui.text = "Press E to Sit"
	
	if player_node:
		var tween = create_tween()
		tween.tween_property(player_node, "global_position", stand_position.global_position, 0.5).set_trans(Tween.TRANS_SINE)
		
		await tween.finished
		player_node.set_physics_process(true)

# --- PROXIMITY SIGNALS ---

func _on_proximity_trigger_body_entered(body: Node3D) -> void:
	if "Player" in body.name and not is_seated:
		is_player_near = true
		player_node = body 
		
		if prompt_ui: 
			prompt_ui.text = "Press E to Sit"
			prompt_ui.show()

func _on_proximity_trigger_body_exited(body: Node3D) -> void:
	if "Player" in body.name:
		is_player_near = false
		
		if not is_seated and prompt_ui: 
			prompt_ui.hide()
