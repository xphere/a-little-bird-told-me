tool
extends Action

signal recieved()
signal opened()
signal closed()
signal selected()

export(Resource) var letter_resource


func _ready() -> void:
	if Engine.editor_hint and not letter_resource:
		letter_resource = LetterResource.new() as Resource

	connect_to(letter_resource)


func execute() -> void:
	owner.register_letter(letter_resource)


func connect_to(node: Object) -> void:
	_connect_to_signal(node, "recieved")
	_connect_to_signal(node, "openened")
	_connect_to_signal(node, "closed")
	_connect_to_signal(node, "selected")


func _connect_to_signal(node: Object, signal_name: String) -> void:
	if node.has_signal(signal_name):
		node.connect(
			signal_name,
			self, "emit_signal", [signal_name],
			CONNECT_DEFERRED
		)
