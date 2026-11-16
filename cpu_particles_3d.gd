extends CPUParticles3D

# Reference the new child RayCast3D node, NOT the particles
@onready var area_3d: Area3D = $Area3D


func _physics_process(_delta: float) -> void:
	if emitting and area_3d.is_colliding():
		var target_3 = area_3d.get_collider()
		print(target_3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
