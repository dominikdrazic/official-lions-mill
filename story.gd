extends Control

@export var videotime = 0
@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	video_stream_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	videotime += delta
	if videotime > 23:
		get_tree().change_scene_to_file("res://Mlin.tscn")
	


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Mlin.tscn")
