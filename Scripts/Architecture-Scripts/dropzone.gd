extends PanelContainer

# You will type the correct answer in the Inspector for each box!
@export var expected_component: String = ""

# Visual States (Opacity)
var normal_color = Color(1, 1, 1, 0.4) # 40% visible (Faded out)
var active_color = Color(1, 1, 1, 1.0) # 100% visible (Lights up!)

func _ready() -> void:
	# Start the game faded out
	modulate = normal_color

# MAGIC STATE CHANGER: Godot calls this automatically when dragging starts/stops!
func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_BEGIN:
		modulate = active_color # Player picked up a card! Light up the dropzone!
	elif what == NOTIFICATION_DRAG_END:
		modulate = normal_color # Player let go. Fade back out.

# 1. Ask: "Am I allowed to accept what the player is holding?"
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	# Only say 'yes' if the data package contains our "badge_scene"
	return typeof(data) == TYPE_DICTIONARY and data.has("badge_scene")

# 2. Action: "The player dropped it on me! Do the thing!"
func _drop_data(at_position: Vector2, data: Variant) -> void:
	# First, clear the box just in case they are replacing an old piece
	for child in get_children():
		child.queue_free()
		
	# Pull the specific dropped scene out of the data package and spawn it!
	var new_badge = data["badge_scene"].instantiate()
	add_child(new_badge)
	
	# Check if they got the puzzle right!
	if data["name"] == expected_component:
		print("CORRECT! You placed the ", data["name"])
	else:
		print("WRONG! Expected: ", expected_component, " but got: ", data["name"])
