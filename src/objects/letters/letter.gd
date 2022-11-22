extends Selectable

signal received()
signal opened()
signal closed()

const LetterResource := preload("res://src/resources/letter.gd")

var _letter : LetterResource


func setup(letter: LetterResource) -> void:
	_letter = letter
	id = _letter.letter_id
	_letter.connect_to(self)


func get_name_when_selected() -> String:
	return _letter.letter_name if _letter.has_been_opened() else "???"


func is_draggable() -> bool:
	return true


func drag_to(position: Vector2) -> void:
	self.global_position = position


func to_message(message_box: Node) -> void:
	message_box.set_contents(_letter.letter_contents)
	message_box.set_type(_letter.letter_type)
