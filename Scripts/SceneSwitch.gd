extends Node

@export var Scene : String

func _sceneSwitch():
	var _scene_tree = get_tree()
	_scene_tree.change_scene_to_file("res://Scenes/" + Scene + ".tscn")
