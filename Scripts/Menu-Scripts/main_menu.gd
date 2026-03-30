extends Node

## Handles the initial landing page logic and entry animations.
func _ready() -> void:
	await play_intro_sequence()

## Sequentially fades in the title, subtitle, and start button.
func play_intro_sequence() -> void:
	var title = $Title
	var subtitle = $Subtitle
	var button = $StartGame
	
	# Reset alpha for animation
	title.modulate.a = 0
	subtitle.modulate.a = 0
	button.modulate.a = 0
	
	var t1 = create_tween()
	t1.tween_property(title, "modulate:a", 1.0, 0.6)
	await t1.finished
	
	await get_tree().create_timer(0.3).timeout
	
	var t2 = create_tween()
	t2.tween_property(subtitle, "modulate:a", 1.0, 0.4)
	await t2.finished
	
	await get_tree().create_timer(0.4).timeout
	
	var t3 = create_tween()
	t3.tween_property(button, "modulate:a", 1.0, 0.2)

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/choose_mode.tscn")
