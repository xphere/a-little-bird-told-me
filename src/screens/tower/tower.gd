extends Control

onready var transitions := [
	$MailDesk,
	$MapDesk,
]


func on_enter() -> void:
	show()


func on_interact(node: Node2D) -> void:
	if transitions.has(node):
		owner.push_screen(node.name)
