extends PanelContainer

@export var dropped_badge_scene: PackedScene 

# These paths now PERFECTLY match the screenshot you sent!
@onready var name_label = $CardPadding/MainRow/TextColumn/VBoxContainer/Title
@onready var icon_rect = $CardPadding/MainRow/IconFrame/IconPadding/IconImage

func _get_drag_data(at_position: Vector2) -> Variant:
	var drag_data = {
		"name": name_label.text, 
		"icon": icon_rect.texture,
		"badge_scene": dropped_badge_scene
	}

	# ... (inside your _get_drag_data function) ...

	var preview = self.duplicate()
	preview.modulate = Color(1, 1, 1, 0.6)
	
	# ADD THIS LINE: Tells the ghost image to let the mouse pass right through it!
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE 
	
	var preview_container = Control.new()
	preview_container.add_child(preview)
	preview.position = -preview.size / 2 
	
	set_drag_preview(preview_container)
	
	return drag_data
