extends Action

export var letter_id : String


func execute() -> void:
	owner.move_letter_to_mail_desk(letter_id)
