extends Resource


var _name : String
var _scene_path : String
var _transitions : Dictionary


func _init(name: String, scene_path: String) -> void:
	_name = name
	_scene_path = scene_path


func register_transition(cue: String, destination: String) -> void:
	_transitions[cue] = destination


func on_cue(cue: String) -> String:
	return _transitions[cue] if _transitions.has(cue) else ""


func get_name() -> String:
	return _name


func get_scene_path() -> String:
	return _scene_path
