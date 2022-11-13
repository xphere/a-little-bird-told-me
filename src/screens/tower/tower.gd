extends Control

onready var transitions := [
	$MailDesk,
	$MapDesk,
]


func on_interact(node: Node2D) -> void:
	if transitions.has(node):
		owner.to_state(node.name)
