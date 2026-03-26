extends Node

@onready var pause_panel = %PausePanel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_button_pressed():
	get_tree().paused = true
	pause_panel.show()
