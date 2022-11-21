extends Selectable


func select(value: bool) -> void:
	.select(value)
	if has_bird():
		get_bird_node().select(value)


func has_bird() -> bool:
	return $Bird.get_child_count() > 0


func get_bird_node() -> Node2D:
	return $Bird.get_child(0) as Node2D


func get_bird() -> BirdResource:
	return get_bird_node().bird_resource if has_bird() else null
