extends Node

var _available := []


func get_available() -> Array:
	return _available.duplicate()


func set_availability(name: String, available: bool) -> void:
	if not has_node(name):
		return

	var node := get_node(name)

	var is_available := _available.has(node)
	if available and not is_available:
		_available.push_back(node)

	elif is_available and not available:
		_available.erase(node)
