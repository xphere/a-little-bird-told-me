extends Sprite


func on_time_change(time_of_day: int) -> void:
	var tween = create_tween()

	tween.tween_property(
		self, "region_rect:position:x",
		16.0 * time_of_day,
		0.3
	).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

	yield(tween, "finished")

	if time_of_day == 5:
		region_rect.position.x = -16.0
