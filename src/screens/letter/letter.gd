extends Control

const Letter := preload("res://src/objects/letters/letter.gd")

var letter : Letter


func on_enter() -> void:
	$Back.visible = owner.has_stacked_state()
	letter = owner.consume_context("#letter")
	$"%MessageBox".set_contents(letter.letter_content)
	letter.emit_signal("opened")
	show()


func on_leave() -> void:
	letter.emit_signal("closed")
	hide()


func _on_Back_pressed() -> void:
	owner.pop_state()