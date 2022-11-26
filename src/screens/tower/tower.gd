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


var wait : GDScriptFunctionState

func on_time_change(time_of_day: String) -> void:
	if wait:
		yield(wait, "completed")

	wait = Wait.all([
		$BackgroundSky.on_time_change(time_of_day),
		$Time.on_time_change(time_of_day),
	])

	yield(wait, "completed")
	wait = null
