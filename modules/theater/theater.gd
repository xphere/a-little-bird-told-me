extends Control


func _ready() -> void:
	$"%Director".register($"%Script".load_scenes())

	var main_scene : String = ProjectSettings.get("application/run/main_scene")
	if main_scene != filename:
		$"%Director".start_at(main_scene)

	$"On Cue".listen(self, "_on_cue")

	var scene_path : String = $"%Director".start()
	if not scene_path.empty():
		_change_scene(scene_path)


func _on_cue(name: String = "") -> void:
	var scene_path : String = $"%Director".on_cue(name)
	if not scene_path.empty():
		_change_scene(scene_path)


func _change_scene(scene_path: String) -> void:
	yield($"%Curtain".down(), "completed")
	$"%Loading".start()
	var loader = $"%StageHand".load_scene(scene_path)
	var scene : PackedScene = yield(loader, "completed")
	var instance : Node = scene.instance()
	$"%Stage".change_scene_to(instance)
	$"%Loading".stop()
	yield($"%Curtain".up(), "completed")
