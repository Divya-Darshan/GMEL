extends RigidBody2D

@onready var back_wheel: RigidBody2D = $back/RigidBody2D
@onready var front_wheel: RigidBody2D = $front/RigidBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $player/AnimatedSprite2D
@onready var button: Button = $Button

var speed := 900.0
var jump_force := -800.0

var float_force := -40.0
var float_interval := 0.07
var float_timer := 0.0

var player: Node = null
var car_active := false

func _ready() -> void:
	set_physics_process(false)
	button.visible = false
	button.pressed.connect(_on_button_pressed)

func _physics_process(delta: float) -> void:
	if not car_active:
		return

	var dir := 0

	if Input.is_action_pressed("d"):
		dir += 1
	if Input.is_action_pressed("a"):
		dir -= 1

	if dir != 0:
		back_wheel.apply_torque_impulse(dir * speed * delta * 60.0)
		front_wheel.apply_torque_impulse(dir * speed * delta * 60.0)

	if Input.is_action_just_pressed("ui_accept"):
		back_wheel.apply_impulse(Vector2(0, jump_force))
		front_wheel.apply_impulse(Vector2(0, jump_force))
		apply_impulse(Vector2(0, jump_force * 0.6))

	if Input.is_action_pressed("ui_accept"):
		float_timer -= delta
		if float_timer <= 0.0:
			apply_central_impulse(Vector2(0, float_force))
			float_timer = float_interval
	else:
		float_timer = 0.0

func _on_area_2d_body_entered(body: Node2D) -> void:
	player = body
	button.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	button.visible = false
	player = null
	car_active = false
	set_physics_process(false)

func _on_button_pressed() -> void:
	if player == null:
		return

	if player.has_method("player"):
		player.player()

	car_active = not car_active
	set_physics_process(car_active)
