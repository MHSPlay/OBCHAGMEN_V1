extends Node3D

@export var SceneName : String
@export var Locked : bool

@export var doorId : int

@onready var _audioPlayer = $AudioStreamPlayer
@onready var player = %CharacterBody3D

func _interact():
	if(Locked):
		for i in player.keys.size():
			if (player.keys[i] == doorId):
				Locked = false
				return
		
		_audioPlayer.play()
		return
	
	var _scene_tree = get_tree()
	_scene_tree.change_scene_to_file("res://Scenes/" + SceneName + ".tscn")
