extends Action

export var sound_path : NodePath


func execute() -> void:
	var node := get_node(sound_path)
	if node and node.has_method("play"):
		node.play()
