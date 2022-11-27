extends Control

var _time_change_queue := Wait.queue()


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


func on_time_change(day: int, time_of_day: int) -> void:
	var turn = yield(
		_time_change_queue.turn(), "completed"
	)

	$Calendar/Margin/Label.text = "Day %d" % [day]

	yield(
		Wait.all([
			_on_time_change_sky($StaticSky, 2 * time_of_day, 1.0),
			_on_time_change_sky($AnimatedSky, 2 * time_of_day + 1, 1.0),
			$Time.on_time_change(time_of_day),
		]),
		"completed"
	)


func _on_time_change_sky(node: Sprite, frame: int, duration: float) -> void:
	var white := Color(1.0, 1.0, 1.0, 1.0)
	var transparent := Color(1.0, 1.0, 1.0, 0.0)

	var dup := node.duplicate(0) as Sprite
	dup.modulate = transparent
	dup.frame = frame
	dup.position = Vector2.ZERO
	node.add_child(dup)

	var tween := node.create_tween()
	tween.tween_property(node, "self_modulate", transparent, duration)
	tween.parallel().tween_property(dup, "modulate", white, duration)
	yield(tween, "finished")

	node.frame = frame
	node.self_modulate = white
	dup.modulate = transparent
	dup.queue_free()
