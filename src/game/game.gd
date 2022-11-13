extends Control


func _on_Cursor_entered(node: CollisionObject2D) -> void:
	var previous_color := node.modulate

	if node.has_method("select"):
		node.select(true)
	else:
		node.modulate = Color(
			2.4 * pow(node.modulate.r, 2.4),
			2.4 * pow(node.modulate.g, 2.4),
			2.4 * pow(node.modulate.b, 2.4),
			node.modulate.a
		)

	if node.has_method("get_name_when_selected"):
		$DialogBox.info(node.get_name_when_selected())

	while true:
		var exited : CanvasItem = yield($Cursor, "exited")
		if exited == node:
			break

	if node.has_method("get_name_when_selected"):
		$DialogBox.hide()

	if node.has_method("select"):
		node.select(false)
	else:
		node.modulate = previous_color


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.is_pressed():
		var selected : Node = $Cursor.selected
		if selected and $CloseUp/MailTray.is_a_parent_of(selected):
			$Message.set_contents(selected.letter_content)
			$Message.show()
