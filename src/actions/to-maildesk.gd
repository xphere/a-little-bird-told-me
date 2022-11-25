extends Action

export var letter_path : NodePath


func execute() -> void:
	var letter := get_node(letter_path)
	if letter:
		owner.to_maildesk(letter.letter_resource)
