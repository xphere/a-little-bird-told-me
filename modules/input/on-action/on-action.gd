extends Node

signal action()


export var enabled := true setget _set_enabled
export var action_name := "ui_accept"

var _is_ready := false

func _ready() -> void:
	_is_ready = true


func _unhandled_input(event: InputEvent) -> void:
	if not enabled or not _is_ready:
		return

	if event.is_action_pressed(action_name):
		get_tree().set_input_as_handled()
		emit_signal("action")


func _set_enabled(value: bool) -> void:
	enabled = value
	set_process_unhandled_input(value)
