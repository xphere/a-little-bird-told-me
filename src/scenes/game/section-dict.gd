extends Node

const COMMON := ".common"

var _available := {
	COMMON: [],
}


func get_available_for(key: String) -> Array:
	var result : Array = _available[COMMON].duplicate()

	if _available.has(key):
		result.append_array(_available[key])

	return result


func set_availability(name: String, available: bool) -> void:
	var split := name.split(".", false, 1)
	var nested := split.size() > 1
	var context = split[0] if nested else COMMON
	var key = split[1] if nested else split[0]

	if not has_node(key):
		return

	var node := get_node(key)
	var is_available := _is_available(context, node)
	if available and not is_available:
		if not _available.has(context):
			_available[context] = []
		_available[context].push_back(node)

	elif is_available and not available:
		_available[context].erase(node)


func _is_available(context: String, node: Node) -> bool:
	return _available.has(context) and _available[context].has(node)
