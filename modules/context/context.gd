extends Node


var _data := {}


func context(name: String):
	return _data[name] if _data.has(name) else null


func consume_context(name: String):
	var result = context(name)
	_data.erase(name)

	return result


func merge(context: Dictionary) -> void:
	for key in context.keys():
		var value = context[key]
		if value == null:
			_data.erase(key)
		else:
			_data[key] = value
