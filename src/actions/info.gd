extends Action

export(String, MULTILINE) var information := ""


func execute() -> void:
	owner.info(information)
