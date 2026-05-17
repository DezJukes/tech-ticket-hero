extends Node

# ==========================================
# 1. VISUAL NODE REFERENCES 
# ==========================================
@onready var menu_wrapper = $MenuWrapper
@onready var play_button = $MenuWrapper/RightPanel/VBoxContainer/PlayButton
@onready var exit_button = $MenuWrapper/RightPanel/VBoxContainer/ExitButton
@onready var logo = $MenuWrapper/RightPanel/Logo

# Level Select & Audio
var level_select_container: VBoxContainer
var click_audio_player: AudioStreamPlayer # NEW: Variable for our audio player!
var menu_music_player: AudioStreamPlayer # Menu background music

func _ready() -> void:
	# --- NEW: SETUP AUDIO PLAYERS ---
	click_audio_player = AudioStreamPlayer.new()
	click_audio_player.stream = load("res://Assets/Audio/pressed-audio.mp3")
	add_child(click_audio_player)
	
	# Setup menu music player
	menu_music_player = AudioStreamPlayer.new()
	menu_music_player.stream = load("res://Assets/Audio/menu-music.mp3")
	menu_music_player.bus = "Master"
	add_child(menu_music_player)
	menu_music_player.play()
	
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
	
	tween.tween_property(node, "position:y", original_y - distance, 0.0)
	tween.tween_interval(duration / 2.0)
	
	tween.tween_property(node, "position:y", original_y, 0.0)
	tween.tween_interval(duration / 2.0)

# ---------------------------------------------------
# VISUAL MENU BUTTON LOGIC
# ---------------------------------------------------
func _on_play_pressed() -> void:
	click_audio_player.play() # Play the sound!
	menu_wrapper.hide()
	level_select_container.show()

func _on_exit_pressed() -> void:
	click_audio_player.play() # Play the sound!
	await get_tree().create_timer(0.15).timeout # Let it play before closing
	get_tree().quit()

func _on_back_pressed() -> void:
	click_audio_player.play() # Play the sound!
	level_select_container.hide()
	menu_wrapper.show()

# ---------------------------------------------------
# LEVEL SCENE TRANSITIONS
# ---------------------------------------------------
# LEVEL 1: CAMPUS
func _on_cms_pressed() -> void:
	click_audio_player.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/Level 1 - School Campus/Level 1 - Game Scene/CMS_game_scene.tscn")

func _on_library_pressed() -> void:
	click_audio_player.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/Level 1 - School Campus/Level 2 - Game Scene/LibrarySystem_game_scene.tscn")

# LEVEL 2: OFFICE
func _on_erp_pressed() -> void:
	click_audio_player.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/Level 2 - The Office/Level 3 - Game Scene/ERP_game_scene.tscn")

func _on_ecommerce_pressed() -> void:
	click_audio_player.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/Level 2 - The Office/Level 4 - Game Scene/E_Commerce_game_scene.tscn")

# LEVEL 3: BIG TECH
func _on_banking_pressed() -> void:
	click_audio_player.play()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/Level 3 - Big Tech Company/Level 5 - Game Scene/Banking_game_scene.tscn")


# ===================================================
# PROCEDURAL LEVEL SELECT (Horizontal Slider)
# ===================================================
func _build_level_select() -> void:
	level_select_container = VBoxContainer.new()
	level_select_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	level_select_container.alignment = BoxContainer.ALIGNMENT_CENTER
	level_select_container.add_theme_constant_override("separation", 20)
	add_child(level_select_container)
	
	# --- MAIN TITLE ---
	var level_lbl = Label.new()
	level_lbl.text = "SELECT DIRECTORY"
	level_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	level_lbl.add_theme_font_size_override("font_size", 48)
	level_lbl.add_theme_color_override("font_color", Color(1, 1, 1)) 
	level_lbl.add_theme_color_override("font_outline_color", Color(0, 0, 0)) 
	level_lbl.add_theme_constant_override("outline_size", 10)
	level_select_container.add_child(level_lbl)
	
	# --- HORIZONTAL SCROLL CONTAINER (The Slider) ---
	var scroll_container = ScrollContainer.new()
	scroll_container.custom_minimum_size = Vector2(1000, 280) 
	scroll_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	
	# Style for the scroll area
	var scroll_style = StyleBoxFlat.new()
	scroll_style.bg_color = Color(0, 0, 0, 0.4) 
	scroll_style.border_color = Color(0, 0, 0, 1) 
	scroll_style.border_width_left = 6
	scroll_style.border_width_top = 6
	scroll_style.border_width_right = 6
	scroll_style.border_width_bottom = 6
	scroll_style.content_margin_left = 30
	scroll_style.content_margin_right = 30
	scroll_style.content_margin_top = 20
	scroll_style.content_margin_bottom = 20 
	
	scroll_container.add_theme_stylebox_override("panel", scroll_style)
	level_select_container.add_child(scroll_container)
	
	# HBox to hold the level columns side-by-side
	var level_row = HBoxContainer.new()
	level_row.add_theme_constant_override("separation", 60) 
	level_row.alignment = BoxContainer.ALIGNMENT_CENTER
	level_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll_container.add_child(level_row)
	
	# ==========================================
	# COLUMN 1: LEVEL 1 (Beginner)
	# ==========================================
	var col1 = _create_category_column("LEVEL 1: CAMPUS")
	level_row.add_child(col1)
	
	var btn_cms = _create_pixel_button("CMS Architecture", "folder")
	btn_cms.pressed.connect(_on_cms_pressed)
	col1.add_child(btn_cms)
	
	var btn_lib = _create_pixel_button("Library System", "folder")
	btn_lib.pressed.connect(_on_library_pressed)
	col1.add_child(btn_lib)
	
	# ==========================================
	# COLUMN 2: LEVEL 2 (Intermediate)
	# ==========================================
	var col2 = _create_category_column("LEVEL 2: OFFICE")
	level_row.add_child(col2)
	
	var btn_erp = _create_pixel_button("ERP Architecture", "folder")
	btn_erp.pressed.connect(_on_erp_pressed)
	col2.add_child(btn_erp)
	
	var btn_ecom = _create_pixel_button("E-Commerce System", "folder")
	btn_ecom.pressed.connect(_on_ecommerce_pressed)
	col2.add_child(btn_ecom)

	# ==========================================
	# COLUMN 3: LEVEL 3 (Advance)
	# ==========================================
	var col3 = _create_category_column("LEVEL 3: BIG TECH")
	level_row.add_child(col3)
	
	var btn_bank = _create_pixel_button("Banking System", "folder")
	btn_bank.pressed.connect(_on_banking_pressed)
	col3.add_child(btn_bank)
	
	# --- RETURN BUTTON ---
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 10)
	level_select_container.add_child(spacer)
	
	var btn_back = _create_pixel_button("< RETURN", "back_arrow")
	btn_back.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	btn_back.custom_minimum_size = Vector2(300, 60) 
	btn_back.pressed.connect(_on_back_pressed)
	level_select_container.add_child(btn_back)

# Helper function to create clean column titles
func _create_category_column(title_text: String) -> VBoxContainer:
	var col = VBoxContainer.new()
	col.add_theme_constant_override("separation", 15)
	col.alignment = BoxContainer.ALIGNMENT_BEGIN 
	
	var lbl = Label.new()
	lbl.text = title_text
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.add_theme_font_size_override("font_size", 28)
	lbl.add_theme_color_override("font_color", Color(1, 0.8, 0.2)) 
	lbl.add_theme_color_override("font_outline_color", Color(0, 0, 0)) 
	lbl.add_theme_constant_override("outline_size", 8)
	col.add_child(lbl)
	
	return col

func _create_pixel_button(btn_text: String, icon_type: String = "") -> Button:
	var btn = Button.new()
	btn.text = btn_text
	btn.custom_minimum_size = Vector2(350, 80) 
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
