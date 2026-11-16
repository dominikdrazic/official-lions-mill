extends StaticBody3D
@export var spin_speed: Vector3 = Vector3(0, 180, 0)


func interact():
	print("Interacted!")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	rotation_degrees += spin_speed * delta
