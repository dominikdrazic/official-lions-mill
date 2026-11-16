extends GPUParticles3D

@onready var gpu_particles_3d: GPUParticles3D = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if gpu_particles_3d.is_colliding():
		var target_3 = gpu_particles_3d.get_collider()
		print(target_3)
	
