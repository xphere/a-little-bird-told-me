extends Node


const SUBTOPIC_SEP := "."


func topic(topic: String) -> Action:
	var split := topic.split(SUBTOPIC_SEP, false, 1)
	if split.size() > 1:
		topic = split[0]

	var node := _by_name(self, topic)
	if node and split.size() > 1:
		node = _by_name(node, split[1])

	return node as Action


static func _by_name(node: Node, action: String) -> Node:
	return node.get_node(action) if node.has_node(action) else null
