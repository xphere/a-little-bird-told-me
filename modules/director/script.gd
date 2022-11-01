extends Node

const NamedScene := preload("./named-scene.gd")

export(String, FILE, "*.json") var script_path


func load_scenes() -> Array:
	var result := []
	for script in _parse_json(script_path):
		var scene_name := script[0] as String
		var scene_path := script[1] as String
		var transitions := script[2] as Dictionary
		var scene := NamedScene.new(scene_name, scene_path)
		for transition in transitions:
			scene.register_transition(transition, transitions[transition])
		result.push_back(scene)
	return result


func _parse_json(path: String) -> Array:
	var file := File.new()
	var fd := file.open(path, File.READ)
	var parsed := JSON.parse(file.get_as_text())

	return parsed.result as Array
