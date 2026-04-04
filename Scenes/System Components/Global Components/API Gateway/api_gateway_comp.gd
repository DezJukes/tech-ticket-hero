extends PanelContainer

# We only need to export the dropped scene, because the UI can't hold a scene file.
@export var dropped_badge_scene: PackedScene 

# Update these $ paths to match your exact node tree!
@onready var name_label = $MarginContainer/HBoxContainer/TextColumn/Title
@onready var icon_rect = $MarginContainer/HBoxContainer/IconFrame/MarginContainer/IconImage

func _get_drag_data(at_position: Vector2) -> Variant:
	# 1. Grab the name and icon DIRECTLY from the UI you built in the editor
	var drag_data = {
		"name": name_label.text, 
		"icon": icon_rect.texture,
		"badge_scene": dropped_badge_scene
	}

	# 2. Create the transparent ghost image
	var preview = self.duplicate()
	preview.modulate = Color(1, 1, 1, 0.6)
	
	var preview_container = Control.new()
	preview_container.add_child(preview)
	preview.position = -preview.size / 2 
	
	set_drag_preview(preview_container)
	
	return drag_data
