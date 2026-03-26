extends Node



func _on_story_mode_pressed():
	get_tree().change_scene_to_file("res://Scenes/game_scene.tscn")


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
