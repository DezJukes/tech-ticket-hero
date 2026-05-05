extends Node
@onready var black_screen = $TITLE/Control/ColorRect
@onready var intro_text = $TITLE/Control/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	play_intro()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func play_intro() -> void:
	black_screen.modulate.a = 1.0
	intro_text.modulate.a = 0.0

	var tween = create_tween()

	tween.tween_property(intro_text, "modulate:a", 1.0, 1.0)
	tween.tween_interval(1.5)
	tween.tween_property(intro_text, "modulate:a", 0.0, 1.0)
	tween.tween_property(black_screen, "modulate:a", 0.0, 1.5)
	
	await tween.finished
	
	$TITLE.queue_free()
