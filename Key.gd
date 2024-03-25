extends Node3D

@export var keyId : int

@onready var player = $"../SubViewportContainer/SubViewport/CharacterBody3D"

func _interact():
	player.keys.append(keyId)
	self.queue_free()
