extends Action

export var path : NodePath
export var signal_name : String


func execute() -> void:
	var node := owner if path.is_empty() else get_node(path)
	if node:
		yield(node, signal_name)
