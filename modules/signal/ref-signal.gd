class_name RefSignal
extends Object


static func to_async() -> void:
	var resource = Resource.new()
	resource.call_deferred("emit_changed")
	yield(resource, "changed")


static func as_async(result) -> GDScriptFunctionState:
	return result if result is GDScriptFunctionState else to_async()
