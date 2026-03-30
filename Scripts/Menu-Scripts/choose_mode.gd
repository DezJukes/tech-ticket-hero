extends Node

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")

func _on_the_office_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_scene.tscn")
