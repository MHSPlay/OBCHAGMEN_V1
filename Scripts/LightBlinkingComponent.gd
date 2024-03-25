extends SpotLight3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if light_energy >= 1:
		for i in 4:
			light_energy = 0.9
			await get_tree().create_timer(0.15).timeout
			light_energy = 0.05
			await get_tree().create_timer(0.1).timeout
		
		light_energy = 0
	else: 
		light_energy += 0.15 * delta
