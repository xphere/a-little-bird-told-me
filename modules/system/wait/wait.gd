class_name Wait
extends Object


static func all(elements: Array) -> void:
	var resource := Resource.new()

	for element in elements:
		element.connect(
			"completed",
			resource, "emit_changed", [],
			Object.CONNECT_DEFERRED | Object.CONNECT_ONESHOT
		)

	for element in elements:
		yield(resource, "changed")


static func queue() -> WaitQueue:
	return WaitQueue.new()


class WaitQueueTurn:
	extends Resource

	var _turn : GDScriptFunctionState

	func _init(turn: GDScriptFunctionState) -> void:
		_turn = turn

	func _notification(what: int) -> void:
		if what == NOTIFICATION_PREDELETE:
			_turn.call_deferred("resume")


class WaitQueue:
	var _current_turn : GDScriptFunctionState

	func turn() -> Resource:
		var prev := _current_turn
		var turn := _wait_to_resume()
		_current_turn = turn

		var next := _wait_to_resume()
		if prev:
			prev.connect("completed", next, "resume")
		else:
			next.call_deferred("resume")

		yield(next, "completed")
		turn.connect("completed", self, "_on_turn", [turn])

		return WaitQueueTurn.new(turn)

	func _wait_to_resume() -> GDScriptFunctionState:
		return _wait_to_resume_yield()

	func _wait_to_resume_yield() -> void:
		yield()

	func _on_turn(turn) -> void:
		if _current_turn == turn:
			_current_turn = null
