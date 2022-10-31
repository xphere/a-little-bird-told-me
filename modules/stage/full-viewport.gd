extends Viewport


func _enter_tree() -> void:
	var parent : CanvasItem = get_parent()
	if parent:
		parent.connect("item_rect_changed", self, "_change_size", [parent])


func _change_size(parent: Control) -> void:
	size = parent.rect_size
