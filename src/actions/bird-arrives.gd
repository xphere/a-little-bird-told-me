tool
class_name BirdArriveAction, "bird.icon.png"
extends Action

export var bird_path : NodePath
export var letter_path : NodePath


func execute() -> void:
	if bird_path.is_empty():
		return

	var bird_resource : BirdResource = get_node(bird_path).bird_resource
	if not letter_path.is_empty():
		bird_resource.carries = get_node(letter_path).letter_resource

	owner.bird_arrives(bird_resource)
