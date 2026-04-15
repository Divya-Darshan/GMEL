extends RigidBody2D

@onready var back_wheel: RigidBody2D = $back/RigidBody2D
@onready var front_wheel: RigidBody2D = $front/RigidBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $player/AnimatedSprite2D

var speed := 900
var jump_force := -800

var float_force := -40.0        # how strong the “fly up” effect is
var float_interval := 0.07      # how often to add the small impulse
var float_timer := 0.0

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	var dir := 0

	if Input.is_action_pressed("d"):
		dir += 1
	if Input.is_action_pressed("a"):
		dir -= 1

	if dir != 0:
		back_wheel.apply_torque_impulse(dir * speed * delta * 60)
		front_wheel.apply_torque_impulse(dir * speed * delta * 60)

	# normal jump impulse
	if Input.is_action_just_pressed("ui_accept"):
		back_wheel.apply_impulse(Vector2(0, jump_force))
		front_wheel.apply_impulse(Vector2(0, jump_force))
		apply_impulse(Vector2(0, jump_force * 0.6))

	# extra slow-fly effect while holding jump
	if Input.is_action_pressed("ui_accept"):
		float_timer -= delta
		if float_timer <= 0.0:
			apply_central_impulse(Vector2(0, float_force))
			float_timer = float_interval
	else:
		float_timer = 0.0

func _on_area_2d_body_entered(body: Node2D) -> void:
	set_physics_process(true)

func _on_area_2d_body_exited(body: Node2D) -> void:
	set_physics_process(false)
