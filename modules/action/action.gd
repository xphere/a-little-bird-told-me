class_name Action
extends Node


func _enter_tree() -> void:
	var node : Node = self
	var iterations := 0
	while node.owner:
		iterations += 1
		node = node.owner
	owner = node


func execute() -> void:
	pass
