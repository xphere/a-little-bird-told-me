class_name RefSignal
extends Object


static func to_async() -> void:
	var resource = ResourceSignal.new()
	resource.call_deferred("emit_signal", "signaled", resource)
	yield(resource, "signaled")


static func as_async(result) -> GDScriptFunctionState:
	return result if result is GDScriptFunctionState else to_async()
