extends VBoxContainer

# Grab the modals from the scene tree
@onready var info_modal = $InformationModalErp
@onready var failed_panel = %FailedModalErp
@onready var success_panel = %SuccessModalErp

# ---------------------------------------------------
# RUNS ONCE WHEN THE INTERFACE LOADS
# ---------------------------------------------------
func _ready() -> void:
	# 1. Force the modal to hide instantly so it doesn't flash on the screen
	info_modal.hide()
	
	# 2. Play our cool animation to introduce it to the player!
	_popup_modal(info_modal)

# ---------------------------------------------------
# INFO MODAL LOGIC
# ---------------------------------------------------
func _on_ticket_details_pressed():
	# Make the modal visible with our juicy pop-up animation
	_popup_modal(info_modal)
	_hide_red_overlay()

func _on_close_info_modal_pressed() -> void:
	info_modal.hide()
	_restore_red_overlay()

# ---------------------------------------------------
# DEPLOY & EVALUATION LOGIC
# ---------------------------------------------------
func _on_deploy_button_pressed() -> void:
	var all_correct = true
	var all_filled = true
	
	var zones = get_tree().get_nodes_in_group("Dropzones")
	
	for zone in zones:
		if zone.has_component == false:
			all_filled = false
		elif zone.current_component != zone.expected_component:
			all_correct = false
			
	# --- THE FINAL DECISION ---
	if all_filled == false:
		print("Player needs to fill all the empty boxes first!")
		return 
		
	# --- THE PURE CODE LOADING SEQUENCE ---
	_show_loading_screen()
	await get_tree().create_timer(1.5).timeout
	_hide_loading_screen()
		
	# --- SHOW THE RESULTS ---
	if all_correct == true:
		print("Puzzle Passed!")
		_hide_red_overlay()
		get_tree().paused = true
		_popup_modal(success_panel)
	else:
		print("Puzzle Failed!")
		_hide_red_overlay()
		get_tree().paused = true
		_popup_modal(failed_panel)

func _on_try_again_pressed() -> void:
	failed_panel.hide()
	get_tree().paused = false
	_restore_red_overlay()

func _on_button_pressed() -> void:
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://Scenes/Level 2 - The Office/Level 3 - Game Scene/ERP_game_scene.tscn")

# ---------------------------------------------------
# THE "SMART" ANIMATION HELPER
# ---------------------------------------------------
func _popup_modal(modal_node: Node) -> void:
	var target_ui: Control = null
	
	# 1. Figure out what kind of node we were given
	if modal_node is CanvasLayer:
		modal_node.show() # Turn the invisible layer on
		for child in modal_node.get_children():
			if child is Control:
				target_ui = child
				break
	elif modal_node is Control:
		target_ui = modal_node
		target_ui.show()

	# 2. If we found a UI panel, let's animate it!
	if target_ui != null:
		target_ui.pivot_offset = target_ui.size / 2
		target_ui.scale = Vector2(0.8, 0.8)
		target_ui.modulate.a = 0.0
		
		var tween = create_tween()
		tween.set_parallel(true)
		# Using the 0.4 timing you requested!
		tween.tween_property(target_ui, "scale", Vector2(1.0, 1.0), 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(target_ui, "modulate:a", 1.0, 0.2)

# ---------------------------------------------------
# RED OVERLAY HELPERS
# ---------------------------------------------------
func _hide_red_overlay() -> void:
	var overlay = get_tree().current_scene.get_node_or_null("CodeErrorCanvas")
	if overlay != null:
		overlay.hide() 

func _restore_red_overlay() -> void:
	var overlay = get_tree().current_scene.get_node_or_null("CodeErrorCanvas")
	if overlay != null:
		overlay.show()

# ---------------------------------------------------
# PURE CODE LOADING SCREEN
# ---------------------------------------------------
func _show_loading_screen() -> void:
	var main_scene = get_tree().current_scene
	
	var canvas = CanvasLayer.new()
	canvas.name = "CodeLoadingCanvas"
	canvas.layer = 105 
	
	var bg = ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0, 0, 0, 0.85) 
	
	var label = Label.new()
	label.text = "Deploying Architecture..."
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.add_theme_font_size_override("font_size", 42) 
	
	var pulse_tween = create_tween().set_loops() 
	pulse_tween.tween_property(label, "modulate:a", 0.3, 0.5) 
	pulse_tween.tween_property(label, "modulate:a", 1.0, 0.5) 
	
	bg.add_child(label)
	canvas.add_child(bg)
	main_scene.add_child(canvas)

func _hide_loading_screen() -> void:
	var canvas = get_tree().current_scene.get_node_or_null("CodeLoadingCanvas")
	if canvas != null:
		canvas.queue_free()
