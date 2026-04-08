extends Node

@onready var pause_panel = %PausePanel
@onready var info_panel = %InformationPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_button_pressed():
	get_tree().paused = true
	pause_panel.show()


func _on_interact_pressed():
	get_tree().paused = true
	info_panel.show()
