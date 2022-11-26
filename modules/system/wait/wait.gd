class_name Wait
extends Object


static func all(elements: Array) -> void:
	var resource := Resource.new()

	for element in elements:
		element.connect(
			"completed",
			resource, "emit_changed", [],
			Object.CONNECT_DEFERRED | Object.CONNECT_ONESHOT
		)

	for element in elements:
		yield(resource, "changed")
