class_name Action, "action.icon.png"
extends Node


func _enter_tree() -> void:
	owner = NodeUtils.top_owner(self)


func execute() -> void:
	pass
