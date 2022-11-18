extends Action

export var letter_path : NodePath


func execute() -> void:
	var letter := get_node(letter_path)
	if letter:
		var instance := _create_letter(letter.letter_resource)
		owner.add_to_maildesk(instance)


func _create_letter(resource: Resource) -> Node2D:
	var scene := preload("res://src/objects/letters/letter.tscn") as PackedScene
	var instance := scene.instance() as Node2D
	resource.connect_to(instance)
	instance.id = resource.letter_id
	instance.letter_name = resource.letter_name
	instance.letter_content = resource.letter_contents
	return instance
