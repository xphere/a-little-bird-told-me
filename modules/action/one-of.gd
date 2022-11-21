class_name ActionOneOf, "one-of.icon.png"
extends Action

var times := 0


func execute() -> void:
	var actions := []
	for child in get_children():
		if child is Action:
			actions.append(child)

	if actions.empty():
		return

	var limit := actions.size() - (1 if times > 0 else 0)
	var rand_index := rand_range(0, limit)
	var action := actions[rand_index] as Action

	times += 1
	action.raise()
	yield(RefSignal.as_async(action.execute()), "completed")
