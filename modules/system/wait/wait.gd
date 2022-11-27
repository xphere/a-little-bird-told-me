class_name Wait
extends Object


static func all(elements: Array) -> void:
	var resource := ResourceSignal.new()

	for element in elements:
		element.connect(
			"completed",
			resource, "emit_signal", ["signaled", resource],
			Object.CONNECT_DEFERRED | Object.CONNECT_ONESHOT
		)

	for element in elements:
		yield(resource, "signaled")


static func queue() -> Queue:
	return Queue.new()


class QueueTurn extends Resource:
	signal finished()

	func finish() -> void:
		emit_signal("finished")


class Queue extends Reference:
	var _queue := []

	func turn() -> QueueTurn:
		var previous := _last_in_line()
		var turn := QueueTurn.new()
		turn.connect(
			"finished",
			self, "_on_turn_finished", [turn],
			CONNECT_DEFERRED
		)
		_queue.push_back(turn)
		if previous:
			yield(previous, "finished")
		else:
			yield(RefSignal.to_async(), "completed")

		return turn

	func _on_turn_finished(turn: QueueTurn) -> void:
		_queue.erase(turn)

	func _last_in_line() -> QueueTurn:
		return null if _queue.empty() else _queue.back()
