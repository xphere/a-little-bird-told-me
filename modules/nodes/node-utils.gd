class_name NodeUtils


static func top_owner(node: Node) -> Node:
	var iterations := 0
	while node.owner:
		node = node.owner
	return node
