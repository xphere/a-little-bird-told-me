extends Node

signal action()


export var enabled := true setget _set_enabled

var _is_ready := false


func _ready() -> void:
	_is_ready = true


func _input(event: InputEvent) -> void:
	if not enabled or not _is_ready:
		return

	var mouse_event := event as InputEventMouseButton
	if not mouse_event:
		return

	if event.is_echo() or not event.is_pressed():
		return

	if mouse_event.button_index != BUTTON_LEFT:
		return

	emit_signal("action")


func _set_enabled(value: bool) -> void:
	enabled = value
	set_process_input(value)
