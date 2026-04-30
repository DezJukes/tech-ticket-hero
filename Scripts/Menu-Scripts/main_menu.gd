extends Node

var master_ui: Control
var center_anchor: CenterContainer

var main_menu_container: VBoxContainer
var level_select_container: VBoxContainer

var title_container: HBoxContainer
var subtitle: Label
var start_button: Button

func _ready() -> void:
	# 1. THE ROOT LAYER & PIXEL FILTERING
	master_ui = Control.new()
	master_ui.set_anchors_preset(Control.PRESET_FULL_RECT)
	# CRITICAL FOR PIXEL VIBES: Forces Godot to render fonts and UI with sharp edges!
	master_ui.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST 
	add_child(master_ui)
	
	# NOTE: Background generation has been completely removed! 
	# Your existing panel will show through perfectly.
	
	# 2. THE ABSOLUTE CENTER ANCHOR
	center_anchor = CenterContainer.new()
	center_anchor.set_anchors_preset(Control.PRESET_FULL_RECT)
	master_ui.add_child(center_anchor)
	
	# 3. BUILD SCREENS
	_build_main_menu()
	_build_level_select()
	
	level_select_container.hide()
	
	# 4. Start Animations (A rigid, robotic float for the pixel vibe)
	animate_pixel_float(title_container, 8.0, 1.0) 
	play_intro_sequence()

# ---------------------------------------------------
# BUILD SCREEN 1: THE MAIN MENU
# ---------------------------------------------------
func _build_main_menu() -> void:
	main_menu_container = VBoxContainer.new()
	main_menu_container.alignment = BoxContainer.ALIGNMENT_CENTER
	main_menu_container.add_theme_constant_override("separation", 20)
	center_anchor.add_child(main_menu_container)
	
	# --- PIXELATED TITLE ---
	title_container = HBoxContainer.new()
	title_container.alignment = BoxContainer.ALIGNMENT_CENTER
	main_menu_container.add_child(title_container)
	
	var title_left = Label.new()
	title_left.text = "TECH TICKET "
	title_left.add_theme_font_size_override("font_size", 64)
	title_left.add_theme_color_override("font_color", Color(0.2, 0.6, 1.0)) # Pixel Blue
	title_left.add_theme_color_override("font_outline_color", Color(0, 0, 0)) # Hard Black Outline
	title_left.add_theme_constant_override("outline_size", 12)
	# Hard pixel drop shadow
	title_left.add_theme_color_override("font_shadow_color", Color(0, 0, 0))
	title_left.add_theme_constant_override("shadow_offset_x", 6)
	title_left.add_theme_constant_override("shadow_offset_y", 6)
	title_container.add_child(title_left)
	
	var title_right = Label.new()
	title_right.text = "HERO"
	title_right.add_theme_font_size_override("font_size", 64)
	title_right.add_theme_color_override("font_color", Color(0.2, 0.9, 0.2)) # Pixel Green
	title_right.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	title_right.add_theme_constant_override("outline_size", 12)
	title_right.add_theme_color_override("font_shadow_color", Color(0, 0, 0))
	title_right.add_theme_constant_override("shadow_offset_x", 6)
	title_right.add_theme_constant_override("shadow_offset_y", 6)
	title_container.add_child(title_right)
	
	# --- RETRO SUBTITLE ---
	subtitle = Label.new()
	subtitle.text = "SYSTEM_ARCHITECTURE"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 24)
	subtitle.add_theme_color_override("font_color", Color(0.2, 0.2, 0.2)) # Dark Gray
	main_menu_container.add_child(subtitle)
	
	# --- CHUNKY START BUTTON ---
	var btn_margin = MarginContainer.new()
	btn_margin.add_theme_constant_override("margin_top", 40) 
	main_menu_container.add_child(btn_margin)
	
	start_button = _create_pixel_button("INSERT DISK (START)")
	start_button.pressed.connect(_on_start_game_pressed)
	btn_margin.add_child(start_button)

# ---------------------------------------------------
# BUILD SCREEN 2: LEVEL SELECTION
# ---------------------------------------------------
func _build_level_select() -> void:
	level_select_container = VBoxContainer.new()
	level_select_container.alignment = BoxContainer.ALIGNMENT_CENTER
	level_select_container.add_theme_constant_override("separation", 24)
	center_anchor.add_child(level_select_container)
	
	# --- PIXEL LEVEL TITLE ---
	var level_lbl = Label.new()
	level_lbl.text = "SELECT DIRECTORY"
	level_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	level_lbl.add_theme_font_size_override("font_size", 48)
	level_lbl.add_theme_color_override("font_color", Color(1, 1, 1)) # White
	level_lbl.add_theme_color_override("font_outline_color", Color(0, 0, 0)) # Black Outline
	level_lbl.add_theme_constant_override("outline_size", 10)
	level_select_container.add_child(level_lbl)
	
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	level_select_container.add_child(spacer)
	
	# --- PIXEL BUTTONS ---
	var btn_office = _create_pixel_button("A:\\ THE_OFFICE")
	btn_office.pressed.connect(_on_the_office_pressed)
	level_select_container.add_child(btn_office)
	
	var btn_tech = _create_pixel_button("B:\\ BIG_TECH_CORP") 
	btn_tech.pressed.connect(_on_big_tech_company_pressed)
	level_select_container.add_child(btn_tech)
	
	var btn_back = _create_pixel_button("< RETURN")
	btn_back.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	btn_back.custom_minimum_size = Vector2(200, 40) 
	btn_back.pressed.connect(_on_back_pressed)
	level_select_container.add_child(btn_back)

# ---------------------------------------------------
# HELPER: CHUNKY PIXEL BUTTON GENERATOR
# ---------------------------------------------------
func _create_pixel_button(btn_text: String) -> Button:
	var btn = Button.new()
	btn.text = btn_text
	btn.custom_minimum_size = Vector2(400, 60)
	btn.add_theme_font_size_override("font_size", 24)
	
	# High contrast colors
	var black = Color(0, 0, 0)
	var white = Color(1, 1, 1)
	
	btn.add_theme_color_override("font_color", black)
	btn.add_theme_color_override("font_hover_color", white)
	btn.add_theme_color_override("font_pressed_color", white)
	
	# NORMAL STYLE: White box, thick black borders to simulate an 8-bit shadow
	var normal_style = StyleBoxFlat.new()
	normal_style.bg_color = white
	normal_style.border_color = black
	# The bottom and right borders are extra thick to look like a retro 3D button
	normal_style.border_width_left = 4
	normal_style.border_width_top = 4
	normal_style.border_width_right = 8 
	normal_style.border_width_bottom = 8 
	# Absolute sharp corners
	normal_style.corner_radius_top_left = 0
	normal_style.corner_radius_top_right = 0
	normal_style.corner_radius_bottom_left = 0
	normal_style.corner_radius_bottom_right = 0
	
	# HOVER STYLE: Inverts to solid black
	var hover_style = normal_style.duplicate()
	hover_style.bg_color = black
	
	# PRESSED STYLE: Shifts the borders to look like the button was pushed "down" into the screen
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

# ---------------------------------------------------
# ANIMATIONS
# ---------------------------------------------------
func play_intro_sequence() -> void:
	title_container.modulate.a = 0
	subtitle.modulate.a = 0
	start_button.modulate.a = 0
	
	var t1 = create_tween()
	t1.tween_property(title_container, "modulate:a", 1.0, 0.6)
	await t1.finished
	
	var t2 = create_tween()
	t2.tween_property(subtitle, "modulate:a", 1.0, 0.4)
	await t2.finished
	
	var t3 = create_tween()
	t3.tween_property(start_button, "modulate:a", 1.0, 0.2)

# Replaced TRANS_STEP with instant snapping and intervals
func animate_pixel_float(node: CanvasItem, distance: float, duration: float) -> void:
	var original_y = node.position.y
	var tween = create_tween().set_loops()
	
	# Snap UP instantly (0.0 seconds), then hold that position
	tween.tween_property(node, "position:y", original_y - distance, 0.0)
	tween.tween_interval(duration / 2.0)
	
	# Snap back to the ORIGINAL position instantly, then hold
	tween.tween_property(node, "position:y", original_y, 0.0)
	tween.tween_interval(duration / 2.0)

# ---------------------------------------------------
# BUTTON LOGIC
# ---------------------------------------------------
func _on_start_game_pressed() -> void:
	main_menu_container.hide()
	level_select_container.show()

func _on_back_pressed() -> void:
	level_select_container.hide()
	main_menu_container.show()

func _on_the_office_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_scene.tscn")

func _on_big_tech_company_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level 2 - Intermediate/Intermediate - Game Scene/ERP_game_scene.tscn")
