class_name ActionRandom, "one-of.icon.png"
extends Action


func _ready() -> void:
	var actions := []
	for child in get_children():
		if child is Action:
			actions.append(child)

	while not actions.empty():
		var index := rand_range(0, actions.size())
		actions[index].raise()
		actions.remove(index)


func execute() -> void:
	for child in get_children():
		if child is Action:
			child.raise()
			yield(RefSignal.as_async(child.execute()), "completed")
			break
