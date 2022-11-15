extends Action

export var path : NodePath
export var signal_name : String


func execute() -> void:
	var node := get_node(path)
	if node:
		yield(node, signal_name)
