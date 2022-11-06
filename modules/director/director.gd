extends Node

const NamedScene := preload("./named-scene.gd")
const Next := "__next__"


var _scenes : Dictionary
var _current_scene : String
var _start_scene : String


func register(scenes: Array) -> void:
	for index in scenes.size():
		_register_scene(scenes[index] as NamedScene)


func register_fallback(scene: String) -> void:
	_register_scene(NamedScene.new("__debug_%s" % hash(scene), scene))


func start_at(scene_path: String) -> void:
	var next_scene := _find_scene_by_path(scene_path)
	if next_scene:
		_start_scene = next_scene.get_name()


func start() -> String:
	if _scenes.empty():
		return ""

	_setup_next()

	return _set_current_scene(_get_start_scene())


func on_cue(cue: String) -> String:
	var current_scene := _scenes[_current_scene] as NamedScene
	if cue.empty():
		cue = Next
	var next_scene := current_scene.on_cue(cue)
	if next_scene.empty():
		return ""
	return _set_current_scene(next_scene)


func _register_scene(scene: NamedScene) -> void:
	_scenes[scene.get_name()] = scene


func _setup_next() -> void:
	var scene_names := _scenes.keys()
	for scene_idx in _scenes.size() - 1:
		var scene := _scenes[scene_names[scene_idx]] as NamedScene
		scene.register_transition(Next, scene_names[scene_idx + 1])


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
