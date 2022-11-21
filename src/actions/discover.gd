class_name ActionDiscover, "discover.icon.png"
extends Action

export var topic : String
export var value : int


func execute() -> void:
	var message := "%s:%d" % [ topic, value ]
	yield(RefSignal.as_async(owner.discover(message)), "completed")
