extends Selectable


func select(value: bool) -> void:
	.select(value)
	if $Bird.get_child_count() > 0:
		$Bird.get_child(0).select(value)
