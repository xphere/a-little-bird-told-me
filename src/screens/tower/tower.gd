extends Control

var _time_change_queue := Wait.queue()


func _ready() -> void:
	$StaticSky.visible = false
	owner.cast("maester", $Maester)
	owner.cast("assistant", $Assistant)


func on_enter() -> void:
	show()


func bird_arrives(bird: BirdResource) -> void:
	$Window.queue_bird(bird)
	update_birds()


func update_birds() -> void:
	$Window.update_bird_queue()


func on_time_change(day: int, time_of_day: int) -> void:
	var immediate : bool = not $StaticSky.visible
	if immediate:
		$StaticSky.visible = true

	var turn : Wait.QueueTurn = yield(
		_time_change_queue.turn(), "completed"
	)

	$Calendar/Margin/Label.text = "Day %d" % [day]

	var time_multiplier := 0.0 if immediate else 1.0

	yield(
		Wait.all([
			$StaticSky.transition(time_of_day, 1.0 * time_multiplier),
			$AnimatedSky.transition(time_of_day, 1.0 * time_multiplier),
			$Time.on_time_change(time_of_day, 0.3 * time_multiplier),
		]),
		"completed"
	)

	turn.finish()
