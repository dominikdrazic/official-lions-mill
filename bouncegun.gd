extends Node3D
@onready var gel_scene = preload("res://gel.tscn")

func _input(event):
	if event.is_action_pressed('fire'):
		var gel = gel_scene.instantiate()
		
		#cpu_particles_3d.restart()
		
		
		
