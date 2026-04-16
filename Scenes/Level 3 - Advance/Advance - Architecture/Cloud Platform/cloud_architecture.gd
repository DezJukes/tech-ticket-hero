extends VBoxContainer

# Grab the modals from the scene tree
@onready var info_modal = $InformationModalCloud
@onready var failed_panel = %FailedModalCloud

# IMPORTANT: Make sure you have your success modal added to your scene tree
# and set as a Unique Name (%) just like your failed_panel!
@onready var success_panel = %SuccessModalCloud

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_ticket_details_pressed():
	# Make the modal visible again!
	info_modal.show()

func _on_deploy_button_pressed() -> void:
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
		get_tree().paused = true
		success_panel.show()
	else:
		print("Puzzle Failed!")
		# Pause the game and show defeat
		get_tree().paused = true
		failed_panel.show()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_scene.tscn")
