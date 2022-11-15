extends Action

export var speaker := ""
export(String, MULTILINE) var dialog := ""
export var characters_per_second := 45
export var wait := true


func execute() -> void:
	var result = owner.dialog(dialog, speaker, characters_per_second)
	if wait:
		yield(result, "completed")
