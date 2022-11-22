extends Resource

signal received()
signal opened()
signal closed()

enum Type {
	Neat,
	Weathered,
	Royal,
}

export var letter_id : String
export(String, MULTILINE) var letter_name : String
export(String, MULTILINE) var letter_contents : String
export(Type) var letter_type := Type.Neat

var _has_been_opened := false


func _init() -> void:
	connect("opened", self, "_on_opened")


func connect_to(node: Node) -> void:
	_connect_to_signal(node, "received")
	_connect_to_signal(node, "opened")
	_connect_to_signal(node, "closed")


func has_been_opened() -> bool:
	return _has_been_opened


func _connect_to_signal(node: Node, signal_name: String) -> void:
	if node.has_signal(signal_name):
		node.connect(
			signal_name,
			self, "emit_signal", [signal_name],
			CONNECT_DEFERRED
		)


func _on_opened() -> void:
	_has_been_opened = true
