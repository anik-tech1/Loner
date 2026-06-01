extends Node

enum FishingState { IDLE, WAITING, BITING, REELING }
var current_state = FishingState.IDLE

@export_group("Minigame Settings")
@export var reel_speed: float = 25.0        
@export var tension_gain: float = 15.0      
@export var tension_recovery: float = 45.0  
@export var fish_escape_speed: float = 3.0  
@export_group("Player")
@export var player_camera: Camera3D

@export_group("UI Elements")
@export var fishing_hud: CanvasLayer
@export var tension_bar: ProgressBar
@export var distance_bar: ProgressBar
@export var status_label: Label
@export var status_label1: Label
@export var distance_label2: Label

@export_group("3D Models")
@export var world_rod: Node3D
@export var hand_rod: Node3D

@export_group("Audio")
@export var sfx_cast: AudioStreamPlayer
@export var sfx_hook: AudioStreamPlayer
@export var sfx_snap: AudioStreamPlayer
@export var sfx_success: AudioStreamPlayer
# NEW: Continuous reel sound slot
@export var sfx_reel: AudioStreamPlayer

var fish_distance: float = 100.0
var line_tension: float = 0.0
var bite_timer: float = 0.0

func _ready():
	if fishing_hud: fishing_hud.hide()
	if world_rod: world_rod.show()
	if hand_rod: hand_rod.hide()

func _process(delta: float) -> void:
	match current_state:
		FishingState.IDLE:
			pass 
				
		FishingState.WAITING:
			bite_timer -= delta
			if bite_timer <= 0:
				current_state = FishingState.BITING
				bite_timer = 1.5 
				if status_label: status_label.text = "A FISH IS BITING!\nCLICK TO HOOK!"
				if sfx_hook: sfx_hook.play()
				
		FishingState.BITING:
			bite_timer -= delta
			if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("reel_in"):
				if status_label: status_label.text = "HOOKED!\nHOLD TO REEL!"
				current_state = FishingState.REELING
			elif bite_timer <= 0:
				if status_label: status_label.text = "It got away..."
				end_fishing()
				
		FishingState.REELING:
			handle_reeling(delta)

func start_fishing() -> void:
	current_state = FishingState.WAITING
	bite_timer = randf_range(2.0, 5.0) 
	fish_distance = 100.0
	line_tension = 0.0
	
	if world_rod: world_rod.hide()
	if hand_rod: hand_rod.show()
	

	if player_camera: 
		player_camera.can_look = false
		
		player_camera.yaw = deg_to_rad(-87.5)
		player_camera.rotation.y = player_camera.yaw
		
		player_camera.pitch = deg_to_rad(-10.0) 
		player_camera.rotation.x = player_camera.pitch
	
	if fishing_hud: fishing_hud.show()
	if status_label: status_label.text = "Waiting for a bite..."
	status_label1.text = "Tension"
	distance_label2.text= "Distance left"
	if sfx_cast: sfx_cast.play()
	
	update_ui()

func handle_reeling(delta: float) -> void:
	if Input.is_action_pressed("interact") or Input.is_action_pressed("reel_in"):
		fish_distance -= reel_speed * delta
		line_tension += tension_gain * delta
		
		# NEW: Play the reeling loop if it isn't already playing
		if sfx_reel and not sfx_reel.playing:
			sfx_reel.play()
	else:
		line_tension -= tension_recovery * delta
		fish_distance += fish_escape_speed * delta
		
		# NEW: Stop the reeling loop immediately when the player lets go
		if sfx_reel and sfx_reel.playing:
			sfx_reel.stop()

	line_tension = clamp(line_tension, 0.0, 100.0)
	update_ui()

	if line_tension >= 100.0:
		if status_label: status_label.text = "SNAP! The line broke!"
		if sfx_snap: sfx_snap.play()
		end_fishing()
	elif fish_distance <= 0.0:
		if status_label: status_label.text = "SUCCESS! Fish Caught!"
		if sfx_success: sfx_success.play()
		Global.Fishes+=1
		end_fishing()

func update_ui() -> void:
	if tension_bar: tension_bar.value = line_tension
	if distance_bar: distance_bar.value = fish_distance

func end_fishing() -> void:
	current_state = FishingState.IDLE
	
	if sfx_reel and sfx_reel.playing:
		sfx_reel.stop()
		
	# NEW: Immediately unlock the camera so the player can look away
	if player_camera: player_camera.can_look = true
		
	await get_tree().create_timer(2.0).timeout 
	if current_state == FishingState.IDLE:
		if fishing_hud: fishing_hud.hide()
		if world_rod: world_rod.show()
		if hand_rod: hand_rod.hide()
