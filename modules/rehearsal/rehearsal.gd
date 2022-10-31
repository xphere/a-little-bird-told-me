extends Node

const main_scene_property_name := "application/run/main_scene"

var _main_scene_path : String


func _enter_tree() -> void:
	if _is_rehearsal():
		_reload_scene()

	queue_free()


func _is_rehearsal() -> bool:
	if not OS.has_feature("editor"):
		return false

	_main_scene_path = ProjectSettings[main_scene_property_name]
	var current_scene_path := _get_current_scene_path()
	if current_scene_path == _main_scene_path:
		return false

	return true


func _reload_scene() -> void:
	ProjectSettings[main_scene_property_name] = _get_current_scene_path()
	get_tree().change_scene(_main_scene_path)


func _get_current_scene_path() -> String:
	var tree := get_tree()
	var current_scene : Node = tree.current_scene

	return current_scene.filename
