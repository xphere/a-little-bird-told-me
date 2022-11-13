extends Selectable

export var letter_name : String
export(String, MULTILINE) var letter_content : String


func get_name_when_selected() -> String:
	return letter_name
