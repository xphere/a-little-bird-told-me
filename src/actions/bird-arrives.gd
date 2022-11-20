tool
extends Action

export var bird_path : NodePath
export var letter_path : NodePath

const BirdResource := preload("res://src/resources/bird.gd")
const BirdScene := preload("res://src/objects/birds/bird.tscn")

func execute() -> void:
	if bird_path.is_empty():
		return

	var bird_resource : BirdResource = get_node(bird_path).bird_resource
	if not letter_path.is_empty():
		bird_resource.carries = get_node(letter_path).letter_resource

	var bird := BirdScene.instance()
	bird.setup(bird_resource)

	owner.bird_arrives(bird)
