extends Control


func _ready() -> void:
	$"%Director".register($"%Script".load_scenes())

	var main_scene : String = ProjectSettings.get("application/run/main_scene")
	if main_scene != filename:
		$"%Director".register_fallback(main_scene)
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
	get_tree().paused = true
	yield($"%Curtain".down(), "completed")
	$"%Loading".start()
	var loader = $"%StageHand".load_scene(scene_path)
	var scene : PackedScene = yield(loader, "completed")
	var instance : Node = scene.instance()
	$"%Stage".change_scene_to(instance)
	yield(instance, "started" if instance.has_signal("started") else "ready")
	$"%Loading".stop()
	get_tree().paused = false
	yield($"%Curtain".up(), "completed")


func _input(event: InputEvent) -> void:
	if event.is_action_type() and event.is_pressed() and not event.is_echo():
		if event.is_action("toggle_music"):
			_toggle_sound_bus("Music")
		elif event.is_action("toggle_sound"):
			_toggle_sound_bus("FX")


func _toggle_sound_bus(bus_name: String) -> void:
	var index := AudioServer.get_bus_index(bus_name)
	var is_muted := AudioServer.is_bus_mute(index)
	AudioServer.set_bus_mute(index, not is_muted)
