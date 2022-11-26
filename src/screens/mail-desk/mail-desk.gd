extends CanvasItem

export var LetterObject : Script
export var LetterScene : PackedScene


func on_enter() -> void:
	$Back.visible = owner.has_stacked_screen()
	show()


func on_leave() -> void:
	hide()


func on_interact(node: Node) -> void:
	if LetterObject.instance_has(node):
		owner.push_screen("Letter", { "#letter": node })


func _on_Back_pressed() -> void:
	owner.pop_screen()


func add_letter(letter: LetterResource) -> void:
	var instance := LetterScene.instance() as Node2D
	instance.setup(letter)

	add_child(instance)
	instance.global_position = Vector2(
		rand_range(40, 256 - 40),
		rand_range(15, 240 - 15)
	)
