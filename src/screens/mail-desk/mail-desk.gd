extends CanvasItem


func on_enter() -> void:
	show()


func on_leave() -> void:
	hide()


func on_interact(node: Node) -> void:
	var Letter := preload("res://src/objects/letters/letter.gd")

	if node is Letter:
		owner.push_state("Letter", { "letter.contents": node.letter_content })


func _on_Back_pressed() -> void:
	owner.pop_state()
