extends Node

@onready var info_panel = %InformationPanel
var click_audio: AudioStreamPlayer
var info_pop_audio: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	click_audio = AudioStreamPlayer.new()
	click_audio.stream = load("res://Assets/Audio/pressed-audio.mp3")
	click_audio.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(click_audio)

	info_pop_audio = AudioStreamPlayer.new()
	info_pop_audio.stream = load("res://Assets/Audio/info-pop-audio.mp3")
	info_pop_audio.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(info_pop_audio)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	var e_key_pressed = Input.is_action_just_pressed("interact")
	if (e_key_pressed == true):
		get_tree().paused = true
		info_pop_audio.play()
		info_panel.show()


func _on_accept_mission_pressed():
	click_audio.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/System Architecture Gameplay/GameInterface.tscn")
