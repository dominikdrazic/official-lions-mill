extends Control

@onready var player: CharacterBody3D = $"../player"

@onready var label: Label = $Label
@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	label.text =  'Wheat: ' + str(player.wheat)
	label_2.text =  'Bounce gun: ' + str(player.Ammo) + '/' + str(player.Maxammo)
	label_3.text =  'Return to mill: ' + str(int(player.time))
