extends CanvasLayer

var click_audio: AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	click_audio = AudioStreamPlayer.new()
	click_audio.stream = load("res://Assets/Audio/pressed-audio.mp3")
	click_audio.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(click_audio)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mission_complete_pressed() -> void:
	click_audio.play()
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")
