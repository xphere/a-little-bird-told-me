extends Action

export(String, MULTILINE) var information := ""


var _info : GDScriptFunctionState


func execute() -> void:
	_info = owner.info(information)


func on_finally() -> void:
	_info.resume()
	_info = null
