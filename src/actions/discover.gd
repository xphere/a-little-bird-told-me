class_name ActionDiscover, "discover.icon.png"
extends Action

export var topic : String
export var value : String


func execute() -> void:
	var message := "%s:%s" % [ topic, value ]
	yield(RefSignal.as_async(owner.discover(message)), "completed")
