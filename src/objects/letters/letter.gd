extends Selectable

signal received()
signal opened()
signal closed()


var letter_name : String
var letter_content : String


func get_name_when_selected() -> String:
	return letter_name


func is_draggable() -> bool:
	return true


func drag_to(position: Vector2) -> void:
	self.global_position = position
