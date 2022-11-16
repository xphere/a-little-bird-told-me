extends Control

onready var transitions := [
	$MailDesk,
]


func _ready() -> void:
	owner.cast("maester", $Maester)
	owner.cast("assistant", $Assistant)


func on_enter() -> void:
	show()


func on_interact(node: Node2D) -> void:
	if transitions.has(node):
		owner.push_screen(node.name)
