extends VBoxContainer

@onready var information_panel: Panel = %InformationPanel
@onready var failed_panel: Panel = %FailedPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_ticket_details_pressed():
	get_tree().paused = true
	information_panel.show()


func _on_deploy_button_pressed() -> void:
	get_tree().paused = true
	failed_panel.show()
