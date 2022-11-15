extends Action

signal received()
signal opened()
signal closed()

export var letter_id : String
export var letter_name : String
export(String, MULTILINE) var letter_contents : String


func execute() -> void:
	owner.register_letter(self)
