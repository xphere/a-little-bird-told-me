extends Sprite


const TimeOffsets := {
	"laudes": 0,
	"prima": 1,
	"tercia": 2,
	"sexta": 3,
	"nona": 4,
	"visperas": 5,
}


func on_time_change(time_of_day: String) -> void:
	var tween = create_tween()

	tween.tween_property(
		self, "region_rect:position:x",
		16.0 * TimeOffsets[time_of_day],
		0.3
	).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

	yield(tween, "finished")

	if time_of_day == "visperas":
		region_rect.position.x = -16.0
