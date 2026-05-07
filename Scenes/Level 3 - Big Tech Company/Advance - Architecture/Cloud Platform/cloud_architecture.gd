extends VBoxContainer

# Grab the modals from the scene tree
@onready var info_modal = $InformationModalCloud
@onready var failed_panel = %FailedModalCloud

# IMPORTANT: Make sure you have your success modal added to your scene tree
# and set as a Unique Name (%) just like your failed_panel!
@onready var success_panel = %SuccessModalCloud

# --- AUDIO PLAYERS ---
var click_audio: AudioStreamPlayer
var success_audio: AudioStreamPlayer
var failed_audio: AudioStreamPlayer
var gameplay_music: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# --- SETUP AUDIO PLAYERS ---
	click_audio = AudioStreamPlayer.new()
	click_audio.stream = load("res://Assets/Audio/pressed-audio.mp3")
	click_audio.process_mode = Node.PROCESS_MODE_ALWAYS 
	add_child(click_audio)
	
	success_audio = AudioStreamPlayer.new()
	success_audio.stream = load("res://Assets/Audio/success-audio.mp3")
	success_audio.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(success_audio)
	
	failed_audio = AudioStreamPlayer.new()
	failed_audio.stream = load("res://Assets/Audio/failed-audio.mp3")
	failed_audio.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(failed_audio)

	# Setup gameplay music
	gameplay_music = AudioStreamPlayer.new()
	gameplay_music.stream = load("res://Assets/Audio/gameplay-music.mp3")
	gameplay_music.bus = "Master"
	add_child(gameplay_music)
	gameplay_music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_ticket_details_pressed():
	click_audio.play() # PLAY SOUND
	# Make the modal visible again!
	info_modal.show()

func _on_deploy_button_pressed() -> void:
	click_audio.play() # PLAY SOUND
	
	var all_correct = true
	var all_filled = true
	
	# Grab every single dropzone on the board using the Group
	var zones = get_tree().get_nodes_in_group("Dropzones")
	
	# Loop through them one by one to check their status
	for zone in zones:
		# 1. Did the player leave any empty?
		if zone.has_component == false:
			all_filled = false
		
		# 2. Is there a piece, but it's the wrong one?
		elif zone.current_component != zone.expected_component:
			all_correct = false
			
	# --- THE FINAL DECISION ---
	
	if all_filled == false:
		print("Player needs to fill all the empty boxes first!")
		# It just returns (stops the function) so the game doesn't pause, 
		# allowing them to keep placing pieces.
		return 
		
	if all_correct == true:
		print("Puzzle Passed!")
		# Pause the game and show victory!
		success_audio.play() # PLAY SUCCESS SOUND!
		get_tree().paused = true
		success_panel.show()
	else:
		print("Puzzle Failed!")
		# Pause the game and show defeat
		failed_audio.play() # PLAY FAILED SOUND!
		get_tree().paused = true
		failed_panel.show()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_scene.tscn")
