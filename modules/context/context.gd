extends Node

var _data := {}


func context(name: String, default_value = null):
	return _data[name] if _data.has(name) else default_value


func context_flag(name: String, flag: String) -> bool:
	return StringUtils.is_flag_set(_data[name], flag) if _data.has(name) else false


func context_count(name: String) -> int:
	return StringUtils.count_flags(str(_data[name])) if _data.has(name) else 0


func consume_context(name: String, default_value = null):
	var result = context(name, default_value)
	_data.erase(name)

	return result


func set_value(key: String, value) -> void:
	if value == null:
		_data.erase(key)
	else:
		_data[key] = value


func set_if_higher(key: String, value: int) -> void:
	if not _data.has(key) or str(_data[key]) == "" or _data[key] < value:
		set_value(key, value)


func set_flag(key: String, flag: String) -> void:
	var value := str(context(key, ""))
	set_value(key, StringUtils.set_flag(value, flag))


func merge(context: Dictionary) -> void:
	for key in context.keys():
		set_value(key, context[key])
