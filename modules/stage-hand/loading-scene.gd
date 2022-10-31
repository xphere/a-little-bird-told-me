extends Reference

signal loaded(path, scene)


var _path : String
var _ril : ResourceInteractiveLoader


func _init(path: String) -> void:
	_path = path
	if ResourceLoader.has_cached(path):
		call_deferred("_resolve", load(path))
	else:
		_ril = ResourceLoader.load_interactive(path, "PackedScene")


func is_loaded() -> bool:
	if _ril == null:
		return true

	var result := _ril.poll()

	# If OK, keep reading
	if result == OK:
		return false

	if result == ERR_FILE_EOF:
		_resolve(_ril.get_resource() as PackedScene)
		return true

	# For other errors notify as finished anyway
	return true


func _resolve(scene: PackedScene) -> void:
	emit_signal("loaded", _path, scene)
