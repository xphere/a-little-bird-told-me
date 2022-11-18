class_name Action
extends Node


func _enter_tree() -> void:
	owner = NodeUtils.top_owner(self)


func execute() -> void:
	pass
