extends Node

export var viewport_path : NodePath

var _current_scene : Node


func change_scene_to(scene: Node) -> void:
	if _current_scene:
		_current_scene.queue_free()
	_current_scene = scene
	get_node(viewport_path).add_child(_current_scene)
