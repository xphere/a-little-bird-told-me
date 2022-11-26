extends TextureRect

const BackgroundColors := {
	"laudes": Color("252437"),
	"prima": Color("898989"),
	"tercia": Color("FFFFFF"),
	"sexta": Color("DFD8A7"),
	"nona": Color("885D19"),
	"visperas": Color("2F1E1E"),
}


func on_time_change(time_of_day: String) -> void:
	var tween := create_tween()

	tween.tween_property(
		self, "modulate",
		BackgroundColors[time_of_day],
		0.3
	)

	yield(tween, "finished")
