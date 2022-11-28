extends Control

const Letter := preload("res://src/objects/letters/letter.gd")

var letter : Letter


func allow_topics(value: bool) -> void:
	$MessageBox.highlight_topics = value


func on_enter() -> void:
	$Back.visible = owner.has_stacked_screen()
	letter = owner.consume_context("#letter")
	letter.to_message($"%MessageBox")
	letter.emit_signal("opened")
	show()


func on_leave() -> void:
	letter.emit_signal("closed")
	hide()


func _on_Back_pressed() -> void:
	owner.pop_screen()
