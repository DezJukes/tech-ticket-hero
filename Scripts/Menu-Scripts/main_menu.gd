extends Node

# Grab the exact paths based on your new Scene Tree!
@onready var title = $CenterAnchor/Title
@onready var subtitle = $CenterAnchor/Subtitle
@onready var start_button = $CenterAnchor/StartGame

## Handles the initial landing page logic and entry animations.
func _ready() -> void:
	# Start floating animations using our new variables
	animate_float(title, 15.0, 2.5)
	animate_float(subtitle, 8.0, 2.5) 
	
	await play_intro_sequence()

## Reusable function to create an infinite bobbing effect.
func animate_float(node: CanvasItem, distance: float, duration: float) -> void:
	var original_y = node.position.y
	
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	
	# Move Up
	tween.tween_property(node, "position:y", original_y - distance, duration / 2)
	# Move Down
	tween.tween_property(node, "position:y", original_y + distance, duration / 2)

## Sequentially fades in the title, subtitle, and start button.
func play_intro_sequence() -> void:
	# Notice we deleted the 'var' lines here and are just using the 
	# @onready variables from the top of the script!
	
	# Reset alpha for animation
	title.modulate.a = 0
	subtitle.modulate.a = 0
	start_button.modulate.a = 0
	
	var t1 = create_tween()
	t1.tween_property(title, "modulate:a", 1.0, 0.6)
	await t1.finished
	
	await get_tree().create_timer(0.3).timeout
	
	var t2 = create_tween()
	t2.tween_property(subtitle, "modulate:a", 1.0, 0.4)
	await t2.finished
	
	await get_tree().create_timer(0.4).timeout
	
	var t3 = create_tween()
	t3.tween_property(start_button, "modulate:a", 1.0, 0.2)

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/choose_mode.tscn")
