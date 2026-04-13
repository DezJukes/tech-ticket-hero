extends PanelContainer

# Type the correct answer in the Inspector for each box
@export var expected_component: String = ""
var current_component: String = ""

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
		# Safely delete whatever component is currently sitting in the box
		for child in get_children():
			child.queue_free() 
			
	# Spawn the fresh, new component from the dragged data
	var new_badge = data["badge_scene"].instantiate()
	add_child(new_badge)
	
	# Lock in the state so it stays full quality
	has_component = true
	modulate = active_color
	
	# Check the puzzle answer
	if data["name"] == expected_component:
		print("CORRECT! You placed the ", data["name"])
	else:
		print("WRONG! Expected: ", expected_component, " but got: ", data["name"])
		# Lock in the state so it stays full quality
	has_component = true
	modulate = active_color
	
	# ADD THIS LINE: Remember the name of the piece currently sitting here!
	current_component = data["name"]
	
	# You can delete your old print("CORRECT!") and print("WRONG!") lines here, 
	# because the Deploy button will handle the checking now!
