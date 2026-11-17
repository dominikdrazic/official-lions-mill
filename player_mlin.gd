extends CharacterBody3D

@export var normal_speed = 2.0
@export var sprint_speed = 3.0
@export var crouch_speed = 1.5

@export var normal_fov = 75.0
@export var sprint_fov = 90.0
@export var fov_trans_speed = 4.0

@export var crouch_offset = -2.0
@export var camera_trans_speed = 5.0
@export var crouch_timer = 0.0

@export var Maxammo = 100
@export var Ammo = 100

@export var wheat = 0 
@export var base_wheat = 0

@export var slide_duration = 3.0
@export var slide_friction = 10.0
@export var slide_speed = 15.0

@export var bounce = 0.0
@export var bounce_timer = 2.0

var speed := 15.0

var fired = false
var bounce_timer_r = 10.0
var is_sliding = false
var slide_timer = 0.0
var slide_direction = Vector3.ZERO
var current_speed = normal_speed
var default_neck_y: float

const JUMP_VELOCITY = 4.5

@onready var neck: Node3D = $neck
@onready var camera: Camera3D = $neck/Camera3D
@onready var animation_player: AnimationPlayer = $"lav_tijelo (1)"/AnimationPlayer
@onready var static_body_3d: StaticBody3D = $"../StaticBody3D"
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var gel_scene = preload("res://gel.tscn")
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

const MOUSE_SENS: float = 0.005

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$neck/lav_glava.hide()
	default_neck_y = neck.position.y

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.pressed:
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var mouse_motion: Vector2 = event.relative 
		rotate_y(-(mouse_motion.x * MOUSE_SENS))
		neck.rotate_x(-(mouse_motion.y * MOUSE_SENS))
		neck.rotation.x = deg_to_rad(clamp(rad_to_deg(neck.rotation.x), -90, 60))

func _physics_process(delta: float) -> void:
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("crouch") and Input.is_action_pressed("sprint") and is_on_floor() and not is_sliding:
		var horizontal_velocity = Vector3(velocity.x, 0, velocity.z)
		if horizontal_velocity.length() > 5.0:
			is_sliding = true
			slide_timer = slide_duration
			slide_direction = horizontal_velocity.normalized()
			velocity.x = slide_direction.x * slide_speed
			velocity.z = slide_direction.z * slide_speed
			
	if is_sliding:
		slide_timer -= delta
		var horizontal_velocity = Vector3(velocity.x, 0, velocity.z)
		horizontal_velocity = horizontal_velocity.move_toward(Vector3.ZERO, slide_friction * delta)
		velocity.x = horizontal_velocity.x
		velocity.z = horizontal_velocity.z
		if slide_timer <= 0 or horizontal_velocity.length() < 2.0 or Input.is_action_just_pressed("jump"):
			is_sliding = false
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_pressed("sprint"):
			current_speed = sprint_speed
		elif Input.is_action_pressed("crouch"):
			current_speed = crouch_speed
		else:
			current_speed = normal_speed
			
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		var input_dir := Input.get_vector("left", "right", "forward", "backward")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * current_speed
			velocity.z = direction.z * current_speed
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed)
			velocity.z = move_toward(velocity.z, 0, current_speed)

	var target_height = default_neck_y
	if (Input.is_action_pressed("crouch") and is_on_floor()) or is_sliding:
		target_height = default_neck_y + crouch_offset
	neck.position.y = lerp(neck.position.y, target_height, camera_trans_speed * delta)

	var target_fov = normal_fov
	if Input.is_action_pressed("sprint") or is_sliding:
		target_fov = sprint_fov
	camera.fov = lerp(camera.fov, target_fov, fov_trans_speed * delta)
	
	if (Input.is_action_pressed("right") or Input.is_action_pressed("left") or Input.is_action_pressed("backward") or Input.is_action_pressed("forward")) and current_speed > 1.0:
		animation_player.play("no_gun_walking")
	elif Input.is_action_pressed("crouch"):
		animation_player.play("crouch")
		crouch_timer += delta
		if crouch_timer > 0.15:
			animation_player.seek(5)
	else: 
		crouch_timer = 0
		animation_player.stop()
	if Input.is_action_just_pressed('mute') and audio_stream_player.playing:
		audio_stream_player.stop()
	elif Input.is_action_just_pressed('mute') and not audio_stream_player.playing:
		audio_stream_player.play()
			
	$CanvasLayer/Label.hide()

	if $"neck/Camera3D/interact cast".is_colliding():
		var target = $"neck/Camera3D/interact cast".get_collider()
		if target != null and target.has_method('interact'):
			$CanvasLayer/Label.show()
			if Input.is_action_just_pressed('interact'):
				wheat += 1
				target.queue_free()
	if $"neck/Camera3D/interact cast".is_colliding():
		var target = $"neck/Camera3D/interact cast".get_collider()
		if target != null and target.has_method('interact1'):
			$CanvasLayer/Label.show()
			if Input.is_action_just_pressed('interact1'):
				Global.flour += Global.wheat/2
				Global.wheat = Global.wheat - (Global.wheat/2)*2
				print(Global.flour)
	if $"neck/Camera3D/interact cast".is_colliding():
		var target = $"neck/Camera3D/interact cast".get_collider()
		if target != null and target.has_method('interact2'):
			$CanvasLayer/Label.show()
			if Input.is_action_just_pressed('interact2'):
				get_tree().change_scene_to_file("res://Main 3d.tscn")
	if $"neck/Camera3D/interact cast".is_colliding():
		var target = $"neck/Camera3D/interact cast".get_collider()
		if target != null and target.has_method('interact3'):
			$CanvasLayer/Label.show()
			if Input.is_action_just_pressed('interact3'):
				Global.bread = Global.flour/100
				print(Global.bread)
				if Global.bread > 0:
					get_tree().change_scene_to_file("res://ending.tscn")
	if $"neck/Camera3D/interact cast".is_colliding():
		var target = $"neck/Camera3D/interact cast".get_collider()
		if target != null and target.has_method('interact7'):
			$CanvasLayer/Label.show()
			if Input.is_action_just_pressed('interact2'):
				get_tree().change_scene_to_file("res://controls.tscn")
	
	move_and_slide()
	
	
	
