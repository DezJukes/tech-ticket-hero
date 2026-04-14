extends PanelContainer

# Type the correct answer in the Inspector for each box
@export var expected_component: String = ""
var current_component: String = ""

# ADDED: Remembers the exact UI card in the toolkit so we can put it back later
var current_card_node: Control = null 

# Visual States (Opacity)
var normal_color = Color(1, 1, 1, 0.4) # 40% visible (Empty)
var active_color = Color(1, 1, 1, 1.0) # 100% visible (Highlighted or Occupied)

# Tracks if a piece is currently sitting in this zone
var has_component: bool = false 

func _ready() -> void:
	modulate = normal_color

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_BEGIN:
		modulate = active_color 
	elif what == NOTIFICATION_DRAG_END:
		if has_component == false:
			modulate = normal_color
		else:
			modulate = active_color

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("badge_scene")

func _drop_data(at_position: Vector2, data: Variant) -> void:
	# --- EXPLICIT REPLACEMENT LOGIC ---
	if has_component:
		print("Replacing old piece with: ", data["name"])
		
		# 1. Safely delete the visual badge sitting in the box
		for child in get_children():
			child.queue_free() 
			
		# 2. ADDED: Un-hide the old card back in the toolkit!
		if current_card_node != null:
			current_card_node.show()

	# 3. ADDED: Hide the NEW card from the toolkit so it looks like we picked it up
	data["original_card"].hide()
			
	# Spawn the fresh, new component from the dragged data
	var new_badge = data["badge_scene"].instantiate()
	new_badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(new_badge)
	
	# Lock in the state so it stays full quality
	has_component = true
	modulate = active_color
	
	# Remember the name of the piece currently sitting here for the Deploy check!
	current_component = data["name"]
	
	# ADDED: Remember the "return address" of this new card in case we replace it later
	current_card_node = data["original_card"]
	
	# This built-in function listens for any mouse clicks on the Dropzone
func _gui_input(event: InputEvent) -> void:
	# Did the player just click the left mouse button?
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		# Is there actually a piece sitting in here to return?
		if has_component:
			print("Returning piece back to the toolkit!")
			
			# 1. Un-hide the original card back in the toolkit sidebar
			if current_card_node != null:
				current_card_node.show()
				
			# 2. Delete the visual badge sitting inside the Dropzone
			for child in get_children():
				child.queue_free()
				
			# 3. Wipe the Dropzone's memory clean so it knows it is empty again
			has_component = false
			current_component = ""
			current_card_node = null
			
			# 4. Return the color to the faded "empty" state
			modulate = normal_color
