class_name NodeUtils


static func top_owner(node: Node) -> Node:
	if node.owner == null:
		node = node.get_parent()

	while node.owner:
		node = node.owner

	return node
