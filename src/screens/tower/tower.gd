extends Control

signal bird_arrived(bird)
signal bird_picked(bird)

var _birds := []
var _current_bird : Node2D


func _ready() -> void:
	owner.cast("maester", $Maester)
	owner.cast("assistant", $Assistant)


func on_enter() -> void:
	show()


func bird_arrives(bird: Node2D) -> void:
	_birds.push_back(bird)
	update_birds()


func update_birds() -> void:
	if not _current_bird and not _birds.empty():
		_current_bird = _birds.pop_front() as Node2D
		$"Window/Bird".add_child(_current_bird)
		emit_signal("bird_arrived", _current_bird.bird_resource)


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
