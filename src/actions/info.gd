extends Action

export(String, MULTILINE) var information := ""


func execute() -> void:
	yield(owner.info(information), "completed")
