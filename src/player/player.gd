extends CharacterBody2D


const SPEED = 280.0
const JUMP_VELOCITY = -900.0

@onready var raycast_right: RayCast2D = $RaycastRight
@onready var raycast_left: RayCast2D = $RaycastLeft

@export var horizontal_speed: float = 250.0
@export var jump_velocity: float = -900.0  # Initial jump impulse
@export var fall_weight: float = 1.5;
@export var max_fall_speed: float = 1200.0 # Max speed when falling
@export var max_jump_hold_time: float = 0.25 # Max time the player can hold the jump button
@export var jump_cut_off: float = 0.5      # Factor to reduce the jump height if the button is released early
@export var max_jumps: int = 2

var jump_number: int = 0
var is_jumping: bool = false
var jump_time: float = 0.0

func _physics_process(delta: float) -> void:
	var horizontal_direction: float = Input.get_axis("ui_left", "ui_right")
	
	if horizontal_direction:
		velocity.x = horizontal_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * fall_weight * delta
		velocity.y = min(velocity.y, max_fall_speed)
		
	if is_on_floor():
		jump_number = 0
	
	# Handle jump start
	if Input.is_action_just_pressed("ui_accept") and jump_number < max_jumps and !is_jumping:
		# Jump velocity is reduced each mid-air jump
		velocity.y = jump_velocity + (jump_number * 200) 
		is_jumping = true
		jump_time = 0.0
		jump_number += 1
	
	# Handle jump duration
	if is_jumping:
		jump_time += delta
		if jump_time > max_jump_hold_time or not Input.is_action_pressed("ui_accept"):
			is_jumping = false
	
	# Handle jump cutoff when releasing the button early
	if not is_jumping and velocity.y < 0:
		velocity.y *= jump_cut_off
		
	if (horizontal_direction > 0.2 and raycast_right.is_colliding()) or (horizontal_direction < -0.2 and raycast_left.is_colliding()):
		velocity.y = 0;
		# Disable subsequent mid-air jumping
		jump_number = max_jumps
		
	# Apply movement using move_and_slide
	move_and_slide()
