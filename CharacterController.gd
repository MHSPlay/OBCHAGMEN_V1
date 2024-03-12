extends CharacterBody3D

# player speed's
class Player:
	const walking_speed = 4.0
	const running_speed = 7.0
	const crouch_speed = 3.5
	const lerp_speed = 10.0

# setup default speed for player
var current_speed = Player.walking_speed
const mouse_sensitivity = 0.25
const jump_velocity = 5.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 2.0
var direction = Vector3.ZERO


func _ready():
	# lock cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	
	#if Input.is_action_pressed("crouch"): # crouching ? we need that ?
	if Input.is_action_pressed("sprint"):
		current_speed = Player.running_speed
	else:
		current_speed = Player.walking_speed
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(direction, ((transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()), Player.lerp_speed * delta)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()

func _input(event):
	# basic camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		$CameraHolder.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		$CameraHolder.rotation.x = clamp($CameraHolder.rotation.x, deg_to_rad(-89), deg_to_rad(89))
