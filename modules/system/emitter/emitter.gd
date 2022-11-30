extends Node

signal emitted()

export(Resource) var _signal = ResourceSignal.new()
export(bool) var enabled := true


func emit(value = "") -> void:
	if not enabled:
		return

	_signal.emit_signal("signaled", value)
	emit_signal("emitted")


func listen(object: Object, method: String, binds := [], flags := 0) -> int:
	return _signal.connect("signaled", object, method, binds, flags)
