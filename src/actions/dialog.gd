class_name ActionDialog, "dialog.icon.png"
extends Action

export var speaker := ""
export(String, MULTILINE) var dialog := ""
export var characters_per_second := 45
export var wait := true

const DynamicString := preload("res://modules/expression/dynamic-string.gd")

var _dialog : DynamicString


func _ready() -> void:
	if DynamicString.is_dynamic(dialog):
		_dialog = DynamicString.new(dialog)


func execute() -> void:
	var text := _dialog.evaluate(owner) if _dialog else dialog
	var result = owner.dialog(text, speaker, characters_per_second)
	if wait:
		yield(result, "completed")
