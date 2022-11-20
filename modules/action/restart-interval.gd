extends Action

export var interval_path : NodePath


func execute() -> void:
	get_node(interval_path).restart()
