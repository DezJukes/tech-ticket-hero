extends CanvasLayer

var click_audio: AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	click_audio = AudioStreamPlayer.new()
	click_audio.stream = load("res://Assets/Audio/pressed-audio.mp3")
	click_audio.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(click_audio)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_accept_button_pressed() -> void:
	click_audio.play()
	self.hide()
