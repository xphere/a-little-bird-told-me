extends Sprite

export var frame_multiplier := 1
export var frame_offset := 0


func transition(layer: int, duration: float) -> void:
	var white := Color(1.0, 1.0, 1.0, 1.0)
	var transparent := Color(1.0, 1.0, 1.0, 0.0)

	var frame = frame_offset + (layer * frame_multiplier)

	var dup := duplicate(0) as Sprite
	dup.modulate = transparent
	dup.frame = frame
	dup.position = Vector2.ZERO
	add_child(dup)

	var tween := create_tween()
	tween.tween_property(self, "self_modulate", transparent, duration)
	tween.parallel().tween_property(dup, "modulate", white, duration)
	yield(tween, "finished")

	self.frame = frame
	self_modulate = white
	dup.modulate = transparent
	dup.queue_free()
