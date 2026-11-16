extends Node3D


@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer






func _ready() -> void:
	audio_stream_player.play()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
