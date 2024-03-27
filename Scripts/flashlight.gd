extends SpotLight3D

# Called every frame. 'delta' is the elapsed time since the previous frame.f
func _process(delta):
	if Input.is_action_just_pressed("flashlight"):
		light_energy = absf((light_energy - 1))
