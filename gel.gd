extends CharacterBody3D
@export var speed: float = 20.0

@onready var gel_pad_scene = preload("res://cilindar.tscn")
var has_collided := false


func _ready() -> void:
	print("alo")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if has_collided:
		return
	var collison = move_and_collide(velocity * delta)
	if collison:
		spawn_gel_pad(collison)
func spawn_gel_pad(collison: KinematicCollision3D):
	has_collided = true
	var gel_pad = gel_pad_scene.instantiate()
	get_tree().current_scene.add_child(gel_pad)
	gel_pad.global_position = collison.get_position() + Vector3(0, -2.23, 0)
	queue_free()
	
	
