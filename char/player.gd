class_name Player extends CharacterBody3D

var mouse_sensitivity: float = 0.15
var _mouse_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK
var gravity: float = -30.0
var state: int
enum States {IDLE, WALK, JUMP, FALL}

@export var speed: float = 8.0
@export var acceleration: float = 20.0
@export var rotation_speed: float = 12.0
@export var jump_impulse: float = 12.0

@onready var body = $Body
@onready var space = $Space
@onready var camera_pivot = $CameraPivot
@onready var camera = $CameraPivot/SpringArm3D/Camera3D
@onready var anima = $AnimationPlayer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	state = States.IDLE

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
		_mouse_input_direction = event.screen_relative * mouse_sensitivity

func _physics_process(delta: float) -> void:
	print(velocity)
	print(state)
	# Camera by Mouse
	camera_pivot.rotation.x -= _mouse_input_direction.y * delta
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI/2.0, PI/8.0)
	camera_pivot.rotation.y -= _mouse_input_direction.x * delta
	_mouse_input_direction = Vector2.ZERO
	# PC Movement
	moving(delta)
	move_and_slide()
	state_logic()

func moving(delta: float) -> void:
	# Determine move direction.
	var movement_input: Vector2 = Input.get_vector("leftward", "rightward", "forward", "backward")
	var forward: Vector3 = camera.global_basis.z
	var right: Vector3 = camera.global_basis.x
	var move_direction: Vector3 = forward * movement_input.y + right * movement_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	# Jump and fall direction.
	var y_velocity: float = velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(move_direction * speed, acceleration * delta)
	velocity.y = y_velocity + gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_impulse
	# Rotate the body.
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	body.global_rotation.y = lerp_angle(body.rotation.y, target_angle, rotation_speed * delta)

func state_logic() -> void:
	match state:
		States.IDLE:
			idle()
		States.WALK:
			walk()
		States.JUMP:
			jump()
		States.FALL:
			fall()

func change_state(next_state: int) -> void:
	anima.stop()
	match next_state:
		States.IDLE:
			anima.play("idle")
		States.WALK:
			anima.play("walk")
		States.JUMP:
			anima.play("jump")
		States.FALL:
			anima.play("fall")
	state = next_state

func idle() -> void:
	if velocity.x != 0.0 or velocity.z != 0.0:
		change_state(States.WALK)
	if not is_on_floor():
		if velocity.y > 0.0:
			change_state(States.JUMP)
		elif velocity.y < 0.0:
			change_state(States.FALL)

func walk() -> void:
	if velocity.x == 0.0:
		change_state(States.IDLE)
	if not is_on_floor():
		if velocity.y > 0.0:
			change_state(States.JUMP)
		elif velocity.y < 0.0:
			change_state(States.FALL)

func jump() -> void:
	if is_on_floor():
		if velocity.x != 0.0 or velocity.z != 0.0:
			change_state(States.WALK)
		else:
			change_state(States.IDLE)
	else:
		if velocity.y < 0.0:
			change_state(States.FALL)

func fall() -> void:
	if is_on_floor():
		if velocity.x != 0.0 or velocity.z != 0.0:
			change_state(States.WALK)
		else:
			change_state(States.IDLE)
