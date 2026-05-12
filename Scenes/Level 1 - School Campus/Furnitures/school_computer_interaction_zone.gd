extends Area2D
signal player_nearby_changed(is_near: bool)

var player_near := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D):
	if body.name == "player":
		player_near = true
		emit_signal("player_nearby_changed", true)


func _on_body_exited(body: Node2D):
	if body.name == "player":
		player_near = false
		emit_signal("player_nearby_changed", false)
