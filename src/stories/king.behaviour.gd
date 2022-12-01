extends Action

export(Resource) var bird = BirdResource.new()
export var send_bird : NodePath

var _talked := []


func react_to(topic: String, closing: String, signature: String) -> void:
	var letter := LetterResource.new()
	letter.letter_type = LetterResource.Type.Royal

	if _talked.has(topic):
		_send_bird()
		return

	match topic:
		"suburbs": pass
		"outsiders": pass

	_send_bird(letter)


func _send_bird(letter: LetterResource = null) -> void:
	var node := get_node(send_bird).duplicate()
	add_child(node)
	node.letter_resource = letter
	owner.plan_action(1, node)
