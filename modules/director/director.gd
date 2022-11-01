extends Node

const NamedScene := preload("./named-scene.gd")


var _scenes : Dictionary
var _current_scene : String
var _start_scene : String


func register(scenes: Array) -> void:
	for index in scenes.size():
		var scene := scenes[index] as NamedScene
		_scenes[scene.get_name()] = scene


func start_at(scene_path: String) -> void:
	var next_scene := _find_scene_by_path(scene_path)
	if next_scene:
		_start_scene = next_scene.get_name()


func start() -> String:
	if _scenes.empty():
		return ""

	return _set_current_scene(_get_start_scene())


func _set_current_scene(scene_name: String) -> String:
	_current_scene = scene_name
	var scene : NamedScene = _scenes[scene_name]

	return scene.get_scene_path()


func _get_start_scene() -> String:
	if _scenes.has(_start_scene):
		return _start_scene

	return _scenes.keys().front()


func _find_scene_by_path(scene_path: String) -> NamedScene:
	for name in _scenes.keys():
		var scene : NamedScene = _scenes[name]
		if scene.get_scene_path() == scene_path:
			return scene

	return null
