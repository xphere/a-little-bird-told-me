extends Node

const LoadingScene := preload("./loading-scene.gd")


var _pending_scenes := []


func load_scene(scene_path: String) -> PackedScene:
	var loading := LoadingScene.new(scene_path)

	_pending_scenes.push_back(loading)
	set_process(true)
	var result : Array = yield(loading, "loaded")

	return result[1]


func _process(delta: float) -> void:
	if _pending_scenes.empty():
		set_process(false)
		return

	var pending : LoadingScene = _pending_scenes.front()
	if pending.is_loaded():
		_pending_scenes.pop_front()
