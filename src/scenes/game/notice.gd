extends Node

onready var _queue := Wait.queue()
onready var _label := find_node("Label")


func notice(text: String, duration: float) -> void:
	var turn : Wait.QueueTurn = yield(_queue.turn(), "completed")
	_label.text = text
	$AnimationPlayer.call_deferred("play", "show")
	yield($AnimationPlayer, "animation_finished")
	yield(get_tree().create_timer(duration), "timeout")
	$AnimationPlayer.call_deferred("play", "hide")
	yield($AnimationPlayer, "animation_finished")
	turn.finish()
