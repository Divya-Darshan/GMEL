extends RigidBody2D

@onready var back_wheel: RigidBody2D = $back/RigidBody2D
@onready var front_wheel: RigidBody2D = $front/RigidBody2D

@onready var enter: Button = $enter
@onready var exit: Button = $exit

@onready var car_camera: Camera2D = $Camera2D
@onready var marker_2d: Marker2D = $Marker2D

var speed := 1200.0
var jump_force := -800.0

var float_force := -40.0
var float_interval := 0.07
var float_timer := 0.0

var player: CharacterBody2D = null
var player_camera: Camera2D = null
var player_collision: CollisionShape2D = null

var car_active := false


func _ready() -> void:
	enter.visible = false
	exit.visible = false

	enter.pressed.connect(enter_car)
	exit.pressed.connect(exit_car)

	car_camera.enabled = false


# ✅ KEY INPUT (E to enter/exit)
func _input(event):
	if event.is_action_pressed("enter"):
		if car_active:
			exit_car()
		else:
			enter_car()


func _physics_process(delta: float) -> void:
	if not car_active:
		return

	var dir := Input.get_axis("a", "d")

	if dir != 0:
		back_wheel.apply_torque_impulse(dir * speed * delta * 60.0)
		front_wheel.apply_torque_impulse(dir * speed * delta * 60.0)

	# ✅ SPACE = JUMP
	if Input.is_action_just_pressed("jump"):
		back_wheel.apply_impulse(Vector2(0, jump_force))
		front_wheel.apply_impulse(Vector2(0, jump_force))
		apply_impulse(Vector2(0, jump_force * 0.6))

	# float
	if Input.is_action_pressed("ui_accept"):
		float_timer -= delta
		if float_timer <= 0.0:
			apply_central_impulse(Vector2(0, float_force))
			float_timer = float_interval
	else:
		float_timer = 0.0


# PLAYER ENTER AREA
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player = body
		player_camera = player.get_node("Camera2D")
		player_collision = player.get_node("CollisionShape2D")

		enter.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player and not car_active:
		enter.visible = false
		player = null


# ENTER CAR
func enter_car():
	if player == null:
		return

	car_active = true

	player.global_position = marker_2d.global_position
	player.visible = false
	player.set_physics_process(false)

	if player_collision:
		player_collision.disabled = true

	if player_camera:
		player_camera.enabled = false
	car_camera.enabled = true

	enter.visible = false
	exit.visible = true


# EXIT CAR
func exit_car():
	car_active = false

	if player != null:
		player.global_position = marker_2d.global_position
		player.visible = true
		player.set_physics_process(true)

		if player_collision:
			player_collision.disabled = false

	if player_camera:
		player_camera.enabled = true
	car_camera.enabled = false

	enter.visible = true
	exit.visible = false
