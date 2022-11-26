extends Control


func _ready() -> void:
	owner.cast("maester", $Maester)
	owner.cast("assistant", $Assistant)


func on_enter() -> void:
	show()


func bird_arrives(bird: BirdResource) -> void:
	$Window.queue_bird(bird)
	update_birds()


func update_birds() -> void:
	$Window.update_bird_queue()


const BackgroundColors := {
	"laudes": Color("FFFFFF"),
	"prima": Color("FFFFFF"),
	"tercia": Color("FFFFFF"),
	"sexta": Color("FFFFFF"),
	"nona": Color("FFFFFF"),
	"visperas": Color("FFFFFF"),
}

var _tween : SceneTreeTween

func on_time_change(time_of_day: String) -> void:
	if _tween and _tween.is_running():
		yield(_tween, "finished")

	_tween = get_tree().create_tween()
	_tween.tween_property(
		$BackgroundSky, "modulate",
		BackgroundColors[time_of_day],
		0.3
	)
