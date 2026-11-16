extends Control

@onready var player: CharacterBody3D = $".."

@onready var label: Label = $Label
@onready var label_3: Label = $Label3

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	label_3.text =  'Total wheat: ' + str(Global.wheat)
	label.text = 'Total flour:' + str(int(Global.flour))
	
