extends CharacterBody3D


# note - i think we don't need that for sound, but AAA project use that.
var is_moving = false

# game state ?
var is_in_pause = false

@onready var Ray = $CameraHolder/RayCast3D


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

func interact():
	# turn on ray cast we need check collider
	Ray.set_enabled(true)
	# check is enabled ?
	if Ray.is_enabled() and Ray.is_colliding():
		var body = Ray.get_collider()
		
		if body.is_in_group("LockedDoor"):
			$AudioStreamPlayer.play()
			
		elif body.is_in_group("Door"):
			print("Door")
		elif body.is_in_group("key"):
			print("key")
			
		else:
			print("something")

func _ready():
	# lock cursor by default
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	## disable raycast we don't need that now
	Ray.set_enabled(false)

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
		is_moving = true
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
		is_moving = false

	move_and_slide()

func _input(event):
	# basic camera rotation this not need to improve
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		$CameraHolder.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		$CameraHolder.rotation.x = clamp($CameraHolder.rotation.x, deg_to_rad(-89), deg_to_rad(89))

	if event.is_pressed():
		if event.is_action_pressed("use"):
			interact()

	# mhsplay - note: i think we need improve that, i don't like this check's on button.
	if event.is_pressed():
		if event.is_action("forward") or event.is_action("left") or event.is_action("backward") or event.is_action("right"):
			if !($FootstepsAudioPlayer.playing) and is_moving:
				$FootstepsAudioPlayer.play()
	elif event.is_echo() and event.is_action_released("forward") and event.is_action_released("left") and event.is_action_released("backward") and event.is_action_released("right"):
		$FootstepsAudioPlayer.stop()

# mhsplay - note: i think we need improve that, i don't like this check's on button.
# mhsplay - note: it's basic func for pause game, menu, setting or other shit.
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE and !is_in_pause:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) #get_tree().quit()
			is_in_pause = true
		elif (event.pressed and event.keycode == KEY_ESCAPE) and is_in_pause: 
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			is_in_pause = false
