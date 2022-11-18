extends Resource

signal received()
signal opened()
signal closed()
signal selected()

export var letter_id : String
export(String, MULTILINE) var letter_name : String
export(String, MULTILINE) var letter_contents : String


func connect_to(node: Node) -> void:
	_connect_to_signal(node, "recieved")
	_connect_to_signal(node, "openened")
	_connect_to_signal(node, "closed")
	_connect_to_signal(node, "selected")


func _connect_to_signal(node: Node, signal_name: String) -> void:
	if node.has_signal(signal_name):
		node.connect(
			signal_name,
			self, "emit_signal", [signal_name],
			CONNECT_DEFERRED
		)
