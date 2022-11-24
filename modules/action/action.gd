class_name Action, "action.icon.png"
extends Node


func _enter_tree() -> void:
	if Engine.editor_hint:
		return
	owner = NodeUtils.top_owner(self)


func execute() -> void:
	pass
