extends RigidBody2D

@onready var back_wheel: RigidBody2D = $back/RigidBody2D
@onready var front_wheel: RigidBody2D = $front/RigidBody2D

@onready var enter: Button = $enter
@onready var exit: Button = $exit

@onready var car_camera: Camera2D = $Camera2D
@onready var marker_2d: Marker2D = $Marker2D

@onready var acc: AudioStreamPlayer2D = $acc
@onready var idle: AudioStreamPlayer2D = $idle
@onready var jump: AudioStreamPlayer2D = $jump

var speed := 1200.0
var jump_force := -800.0

var float_force := -40.0
var float_interval := 0.07
var float_timer := 0.0

var player: CharacterBody2D = null
var player_camera: Camera2D = null
var player_collision: CollisionShape2D = null

var car_active := false

# === CAMERA SHAKE ===
var shake_strength := 20.0
var shake_duration := 0.25
var shake_decay := 20.0

var shake_time := 0.0
var current_shake_power := 0.0


func car():
	pass


func _ready() -> void:
	enter.visible = false
	exit.visible = false

	enter.pressed.connect(enter_car)
	exit.pressed.connect(exit_car)

	car_camera.enabled = false

	# connect breakable boxes
	for box in get_tree().get_nodes_in_group("breakable"):
		if box.has_signal("hit_object"):
			box.hit_object.connect(_on_object_hit)


# INPUT (ENTER to enter/exit)
func _input(event):
	if event.is_action_pressed("enter"):
		if car_active:
			exit_car()
		else:
			enter_car()

func play_jump_audio():
	if jump.playing:
		jump.stop() # restart cleanly
	jump.play()

func _process(delta):
	update_camera_shake(delta)


func _physics_process(delta: float) -> void:
	if not car_active:
		stop_all_sounds()
		return

	var dir := Input.get_axis("a", "d")

	# === MOVEMENT ===
	if dir != 0:
		back_wheel.apply_torque_impulse(dir * speed * delta * 60.0)
		front_wheel.apply_torque_impulse(dir * speed * delta * 60.0)

	# === AUDIO CONTROL ===
	update_engine_audio(dir)

	# JUMP
	if Input.is_action_just_pressed("jump"):
		back_wheel.apply_impulse(Vector2(0, jump_force))
		front_wheel.apply_impulse(Vector2(0, jump_force))
		apply_impulse(Vector2(0, jump_force * 0.6))

		play_jump_audio() # 🔊 ADD THIS

	# FLOAT
	if Input.is_action_pressed("ui_accept"):
		float_timer -= delta
		if float_timer <= 0.0:
			apply_central_impulse(Vector2(0, float_force))
			float_timer = float_interval
	else:
		float_timer = 0.0


# === AUDIO LOGIC ===
func update_engine_audio(dir: float):
	if abs(dir) > 0.1:
		# 🚗 MOVING → ACC SOUND
		if not acc.playing:
			acc.play()
		if idle.playing:
			idle.stop()
	else:
		# 🚗 IDLE → IDLE SOUND
		if not idle.playing:
			idle.play()
		if acc.playing:
			acc.stop()


func stop_all_sounds():
	if acc.playing:
		acc.stop()
	if idle.playing:
		idle.stop()


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

	# 🔊 start idle sound immediately
	idle.play()


# EXIT CAR
func exit_car():
	car_active = false

	stop_all_sounds()

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


# === CAMERA SHAKE ===
func _on_object_hit(strength):
	start_shake(strength)


func start_shake(strength):
	current_shake_power = shake_strength * clamp(strength, 0.5, 3.0)
	shake_time = shake_duration


func update_camera_shake(delta):
	if not car_camera.enabled:
		return

	if shake_time > 0.0:
		shake_time -= delta

		var t = shake_time / shake_duration
		var power = current_shake_power * pow(t, 2)

		car_camera.offset = Vector2(
			randf_range(-1, 1),
			randf_range(-1, 1)
		) * power
	else:
		car_camera.offset = car_camera.offset.lerp(Vector2.ZERO, shake_decay * delta)
