extends CanvasLayer

var click_audio: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# --- SETUP AUDIO PLAYERS ---
	click_audio = AudioStreamPlayer.new()
	click_audio.stream = load("res://Assets/Audio/pressed-audio.mp3")
	# Allow sound to play even if the game is paused!
	click_audio.process_mode = Node.PROCESS_MODE_ALWAYS 
	add_child(click_audio)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_accept_button_pressed() -> void:
	get_tree().paused = false
	click_audio.play() # 1. Play the sound FIRST
	
	# 2. Wait a fraction of a second for the "click" to be heard
	await get_tree().create_timer(1).timeout 
	
	# 3. NOW change the scene!
	get_tree().change_scene_to_file("res://Scenes/Level 1 - School Campus/Level 2 - Architecture/Library_Architecture.tscn")


func _on_button_pressed() -> void:
	get_tree().paused = false
	click_audio.play() # 1. Play the sound FIRST
	
	# 2. Wait a fraction of a second
	await get_tree().create_timer(1).timeout 
	
	# 3. NOW change the scene!
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	click_audio.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")
