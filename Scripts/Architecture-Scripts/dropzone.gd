extends PanelContainer

@export var expected_component: String = ""
var current_component: String = ""
var current_card_node: Control = null 

# ADDED: We need to remember what the picture is so we can drag it again!
var current_badge_scene: PackedScene = null

var normal_color = Color(1, 1, 1, 0.4)
var active_color = Color(1, 1, 1, 1.0) 
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
	if has_component:
		for child in get_children():
			child.queue_free() 
		if current_card_node != null:
			current_card_node.show()

	data["original_card"].hide()
			
	var new_badge = data["badge_scene"].instantiate()
	new_badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(new_badge)
	
	has_component = true
	modulate = active_color
	current_component = data["name"]
	current_card_node = data["original_card"]
	
	# ADDED: Save the scene in case the player drags it away later!
	current_badge_scene = data["badge_scene"]

# ---------------------------------------------------
# NEW FEATURE: Dragging from Dropzone to Dropzone
# ---------------------------------------------------
func _get_drag_data(at_position: Vector2) -> Variant:
	# Empty boxes can't be dragged!
	if not has_component:
		return null 
		
	# 1. Package the exact same invisible shipping label the toolkit uses
	var drag_data = {
		"name": current_component,
		"badge_scene": current_badge_scene,
		"original_card": current_card_node
	}
	
	# 2. Create the floating ghost preview
	var preview = current_badge_scene.instantiate()
	preview.modulate = Color(1, 1, 1, 0.6)
	var preview_container = Control.new()
	preview_container.add_child(preview)
	preview.position = Vector2(-30, -30) # Keeps the ghost roughly centered on mouse
	set_drag_preview(preview_container)
	
	# 3. Instantly wipe THIS Dropzone clean. 
	# (If the drop fails, the piece is already safely back in the toolkit!)
	current_card_node.show()
	for child in get_children():
		child.queue_free()
		
	has_component = false
	current_component = ""
	current_card_node = null
	current_badge_scene = null
	modulate = normal_color
	
	return drag_data

# ---------------------------------------------------
# UPDATED: Click to Return (Tap to Remove)
# ---------------------------------------------------
func _gui_input(event: InputEvent) -> void:
	# CHANGED: We now listen for 'is_released()' instead of 'pressed'.
	# This stops a simple click from interfering with a click-and-drag!
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		
		if has_component:
			if current_card_node != null:
				current_card_node.show()
			for child in get_children():
				child.queue_free()
				
			has_component = false
			current_component = ""
			current_card_node = null
			current_badge_scene = null
			modulate = normal_color
