class_name Player extends CharacterBody3D

var mouse_sensitivity: float = 0.15
var _mouse_input_dir := Vector2.ZERO
var _last_movement_dir := Vector3.ZERO
var movement_input := Vector2.ZERO

@export var speed: float = 5.0
@export var gravity: float = -9.0
@export var jump_velocity: float = 5.0

@onready var body = $Body
@onready var space = $Space
@onready var camera_pivot = $CameraPivot

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()

func _unhandled_input(event: InputEvent) -> void:
	# Rotate Camera
	var is_mouse_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_mouse_motion:
		_mouse_input_dir = event.screen_relative * mouse_sensitivity

func _physics_process(delta: float) -> void:
	# Camera by Mouse
	camera_pivot.rotation.x -= _mouse_input_dir.y * delta
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI/2.0, PI/8.0)
	camera_pivot.rotation.y -= _mouse_input_dir.x * delta
	_mouse_input_dir = Vector2.ZERO
	# PC Movement
	moving(delta)
	jumping(delta)
	move_and_slide()

func moving(delta: float) -> void:
	movement_input = Input.get_vector("leftward", "rightward", "forward", "backward") \
		.rotated(-camera_pivot.global_rotation.y)
	var vel_2d = Vector2(velocity.x, velocity.z)
	if movement_input != Vector2.ZERO:
		vel_2d += movement_input * speed * delta
		vel_2d = vel_2d.limit_length(speed)
	else:
		vel_2d = vel_2d.move_toward(Vector2.ZERO, (speed ** 2) * delta)
	velocity.x = vel_2d.x
	velocity.z = vel_2d.y
	if movement_input.length() > 0.2:
		_last_movement_dir = velocity
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_dir, Vector3.UP)
	body.global_rotation.y = target_angle

func jumping(delta: float) -> void:
	velocity.y += gravity * delta
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y += jump_velocity
