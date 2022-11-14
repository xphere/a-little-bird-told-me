extends Selectable

signal received()
signal opened()
signal closed()


var letter_name : String
var letter_content : String


func get_name_when_selected() -> String:
	return letter_name
