extends Selectable

signal received()
signal opened()
signal closed()

var letter_name : String
var letter_content : String

var _letter : Resource


func setup(letter: Resource) -> void:
	_letter = letter
	id = _letter.letter_id
	letter_name = _letter.letter_name
	letter_content = _letter.letter_contents
	_letter.connect_to(self)


func get_name_when_selected() -> String:
	return letter_name if _letter.has_been_opened() else "???"


func is_draggable() -> bool:
	return true


func drag_to(position: Vector2) -> void:
	self.global_position = position
