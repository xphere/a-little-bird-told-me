extends Selectable

signal pressed()


func on_interact() -> void:
	emit_signal("pressed")
	select(false)
