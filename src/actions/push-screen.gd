extends Action

export var screen_name : String = ""


func execute() -> void:
	owner.push_screen(screen_name)
