extends Node2D
@onready var pause_panel = %PausePanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_interact_pressed() -> void:
	pass # Replace with function body.


func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	pause_panel.show()
