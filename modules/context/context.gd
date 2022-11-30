extends Node

var _data := {}


func context(name: String, default_value = null):
	return _data[name] if _data.has(name) else default_value


func context_flag(name: String, flag: String) -> bool:
	return (
		StringUtils.is_flag_set(str(_data[name]), flag)
		if _data.has(name)
		else false
	)


func context_flag_count(name: String) -> int:
	return (
		StringUtils.flag_count(str(_data[name]))
		if _data.has(name)
		else 0
	)


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
	if _is_higher(key, value):
		set_value(key, value)


func _is_higher(key: String, value: int) -> bool:
	if not _data.has(key):
		return true

	var stored = _data[key]
	if stored is int and stored > value:
		return true

	return str(stored) == ""


func set_flag(key: String, flag: String) -> void:
	var value := str(context(key, ""))
	set_value(key, StringUtils.set_flag(value, flag))


func merge(context: Dictionary) -> void:
	for key in context.keys():
		set_value(key, context[key])
