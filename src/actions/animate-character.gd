class_name ActionAnimateCharacter
extends Action

export var character_name := ""
export var animation_name := "idle"


func execute() -> void:
	owner.animate(character_name, animation_name)
