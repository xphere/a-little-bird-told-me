extends Node


var _data := {}


func context(name: String, default_value = null):
	return _data[name] if _data.has(name) else default_value


func consume_context(name: String, default_value = null):
	var result = context(name, default_value)
	_data.erase(name)

	return result


func merge(context: Dictionary) -> void:
	for key in context.keys():
		var value = context[key]
		if value == null:
			_data.erase(key)
		else:
			_data[key] = value
