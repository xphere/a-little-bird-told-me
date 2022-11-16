extends Action


export var character_name := ""
export var is_leaving := false


func execute() -> void:
	var character : Node2D = owner.character(character_name)
	if is_leaving:
		character.hide()
	else:
		character.show()
