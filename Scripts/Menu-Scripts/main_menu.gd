extends Node

# ==========================================
# 1. VISUAL NODE REFERENCES (Updated Paths!)
# ==========================================
@onready var menu_wrapper = $MenuWrapper
@onready var play_button = $MenuWrapper/RightPanel/VBoxContainer/PlayButton
@onready var exit_button = $MenuWrapper/RightPanel/VBoxContainer/ExitButton
@onready var logo = $MenuWrapper/RightPanel/Logo

# Level Select (Still generated via code)
var level_select_container: VBoxContainer

func _ready() -> void:
	# 1. Connect your visual buttons!
	play_button.pressed.connect(_on_play_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	
	# 2. Build the Level Select screen
	_build_level_select()
	level_select_container.hide() # Hide it at start
	
	# 3. Add some juice! Float the logo and fade in the menu
	animate_pixel_float(logo, 8.0, 1.0) 
	play_intro_sequence()

# ---------------------------------------------------
# ANIMATIONS
# ---------------------------------------------------
func play_intro_sequence() -> void:
	menu_wrapper.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(menu_wrapper, "modulate:a", 1.0, 0.6)

func animate_pixel_float(node: CanvasItem, distance: float, duration: float) -> void:
	var original_y = node.position.y
	var tween = create_tween().set_loops()
	
	# Make it perfectly snap up and down for retro pixel vibes
	tween.tween_property(node, "position:y", original_y - distance, 0.0)
	tween.tween_interval(duration / 2.0)
	
	tween.tween_property(node, "position:y", original_y, 0.0)
	tween.tween_interval(duration / 2.0)

# ---------------------------------------------------
# VISUAL MENU BUTTON LOGIC
# ---------------------------------------------------
func _on_play_pressed() -> void:
	menu_wrapper.hide()
	level_select_container.show()

func _on_exit_pressed() -> void:
	get_tree().quit() # Closes the game

func _on_back_pressed() -> void:
	level_select_container.hide()
	menu_wrapper.show() # Brings your visual menu back!

# ---------------------------------------------------
# LEVEL SCENE TRANSITIONS
# ---------------------------------------------------
func _on_the_office_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level 1 - School Campus/Level 1 - Game Scene/CMS_game_scene.tscn")

func _on_big_tech_company_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level 2 - The Office/Level 4 - Game Scene/E_Commerce_game_scene.tscn")


# ===================================================
# PROCEDURAL LEVEL SELECT (Unchanged)
# ===================================================
func _build_level_select() -> void:
	level_select_container = VBoxContainer.new()
	level_select_container.set_anchors_preset(Control.PRESET_FULL_RECT) # Fills screen
	level_select_container.alignment = BoxContainer.ALIGNMENT_CENTER
	level_select_container.add_theme_constant_override("separation", 24)
	add_child(level_select_container)
	
	var level_lbl = Label.new()
	level_lbl.text = "SELECT DIRECTORY"
	level_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	level_lbl.add_theme_font_size_override("font_size", 48)
	level_lbl.add_theme_color_override("font_color", Color(1, 1, 1)) 
	level_lbl.add_theme_color_override("font_outline_color", Color(0, 0, 0)) 
	level_lbl.add_theme_constant_override("outline_size", 10)
	level_select_container.add_child(level_lbl)
	
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	level_select_container.add_child(spacer)
	
	# --- MASSIVE PIXEL BUTTONS ---
	var btn_office = _create_pixel_button("A:\\ THE_OFFICE", "folder")
	btn_office.pressed.connect(_on_the_office_pressed)
	level_select_container.add_child(btn_office)
	
	var btn_tech = _create_pixel_button("B:\\ BIG_TECH_CORP", "folder") 
	btn_tech.pressed.connect(_on_big_tech_company_pressed)
	level_select_container.add_child(btn_tech)
	
	var btn_back = _create_pixel_button("< RETURN", "back_arrow")
	btn_back.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	btn_back.custom_minimum_size = Vector2(300, 60) 
	btn_back.pressed.connect(_on_back_pressed)
	level_select_container.add_child(btn_back)

func _create_pixel_button(btn_text: String, icon_type: String = "") -> Button:
	var btn = Button.new()
	btn.text = btn_text
	btn.custom_minimum_size = Vector2(450, 80) 
	btn.add_theme_font_size_override("font_size", 24)
	
	if icon_type != "":
		var generated_icon = _generate_retro_icon(icon_type)
		if generated_icon != null:
			btn.icon = generated_icon
			btn.expand_icon = true
			btn.add_theme_constant_override("icon_max_width", 64) 
			btn.add_theme_constant_override("h_separation", 24)   
			btn.alignment = HORIZONTAL_ALIGNMENT_CENTER           
	
	var black = Color(0, 0, 0)
	var white = Color(1, 1, 1)
	
	btn.add_theme_color_override("font_color", black)
	btn.add_theme_color_override("font_hover_color", white)
	btn.add_theme_color_override("font_pressed_color", white)
	
	var normal_style = StyleBoxFlat.new()
	normal_style.bg_color = white
	normal_style.border_color = black
	normal_style.border_width_left = 4
	normal_style.border_width_top = 4
	normal_style.border_width_right = 8 
	normal_style.border_width_bottom = 8 
	
	var hover_style = normal_style.duplicate()
	hover_style.bg_color = black
	
	var pressed_style = normal_style.duplicate()
	pressed_style.bg_color = black
	pressed_style.border_width_left = 8
	pressed_style.border_width_top = 8
	pressed_style.border_width_right = 4 
	pressed_style.border_width_bottom = 4 
	
	btn.add_theme_stylebox_override("normal", normal_style)
	btn.add_theme_stylebox_override("hover", hover_style)
	btn.add_theme_stylebox_override("pressed", pressed_style)
	
	return btn

func _generate_retro_icon(icon_type: String) -> ImageTexture:
	var pixel_data = []
	if icon_type == "disk":
		pixel_data = [
			".XXXXXXXXXXXXXX.",
			"XXLLLLLLLLLLLLXX",
			"X.LWWWWWWWWWWL.X",
			"X.LWWWWWWWWWWL.X",
			"X.LWWXWWWWXWWL.X",
			"X.LLLLLLLLLLLL.X",
			"XXBBBBBBBBBBBBXX",
			"XXBBBBBBBBBBBBXX",
			"XXBWWWWWWWWWWBXX",
			"XXBWRRRRRYYYWBXX",
			"XXBWWWWWWWWWWBXX",
			"XXBWBBBBBBBBWBXX",
			"XXBWWWWWWWWWWBXX",
			"XXBBBBBBBBBBBBXX",
			"XXBBBBBBBBBBBBXX",
			".XXXXXXXXXXXXXX."
		]
	elif icon_type == "folder":
		pixel_data = [
			"................",
			"..XXXX..........",
			".XYYYYX.........",
			"XYYYYYYXXXXXXX..",
			"XYYWWWWWWWWWWX..",
			"XYWWWWWWWWWWWX.X",
			"XYWWXWWWWXWWWXXX",
			"XXOOOOOOOOOOOOX.",
			"XOOOOOOOOOOOOOX.",
			"XOOOOOOOOOOOOOX.",
			"XOOOOOOOOOOOOOX.",
			"XOOOOOOOOOOOOOX.",
			"XOOOOOOOOOOOOOX.",
			"XOOOOOOOOOOOOOX.",
			".XXXXXXXXXXXXX..",
			"................"
		]
	elif icon_type == "back_arrow":
		pixel_data = [
			"................",
			".......XX.......",
			"......XRX.......",
			".....XRRX.......",
			"....XRRRX.......",
			"...XRRRRXXXXXX..",
			"..XRRRRRRRRRRX..",
			".XRRRRRRRRRRRX..",
			".XRRRRRRRRRRRX..",
			"..XRRRRRRRRRRX..",
			"...XRRRRXXXXXX..",
			"....XRRRX.......",
			".....XRRX.......",
			"......XRX.......",
			".......XX.......",
			"................"
		]
	else:
		return null

	var image = Image.create(16, 16, false, Image.FORMAT_RGBA8)
	var palette = {
		".": Color(0, 0, 0, 0),
		"X": Color(0.1, 0.1, 0.1, 1),
		"W": Color(1.0, 1.0, 1.0, 1),
		"L": Color(0.7, 0.7, 0.7, 1),
		"B": Color(0.2, 0.6, 1.0, 1),
		"R": Color(0.9, 0.2, 0.2, 1),
		"Y": Color(1.0, 0.9, 0.2, 1),
		"O": Color(1.0, 0.6, 0.0, 1) 
	}
	
	for y in range(16):
		var row = pixel_data[y]
		for x in range(16):
			var char = row[x]
			if palette.has(char):
				image.set_pixel(x, y, palette[char])
			else:
				image.set_pixel(x, y, Color(1, 0, 1, 1))

	return ImageTexture.create_from_image(image)
