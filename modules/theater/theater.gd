extends Control


func _ready() -> void:
	var main_scene : String = ProjectSettings.get("application/run/main_scene")
	if main_scene != filename:
		_load_scene(main_scene)


func _load_scene(scene_path: String) -> void:
	var scene : PackedScene = yield($"%StageHand".load_scene(scene_path), "completed")
	var instance : Node = scene.instance()
	$"%Stage".change_scene_to(instance)
