extends Action


func execute() -> void:
	var children := []
	var resource = Resource.new()
	for child in get_children():
		if child is Action:
			children.push_back(child)
			RefSignal.as_async(child.execute()).connect(
				"completed",
				self, "_on_child_complete",
				[child, children, resource],
				CONNECT_DEFERRED | CONNECT_ONESHOT
			)
	yield(resource, "changed")


func _on_child_complete(child: Node, children: Array, resource: Resource) -> void:
	children.erase(child)
	if children.empty():
		resource.emit_signal("changed")
