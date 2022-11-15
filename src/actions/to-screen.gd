extends Action

export var screen_name : String = "Tower"


func execute() -> void:
	owner.to_screen(screen_name)
