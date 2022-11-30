tool
class_name BirdRegisterAction, "bird.icon.png"
extends Action

signal picked()

export(Resource) var bird_resource


func _ready() -> void:
	if Engine.editor_hint and not bird_resource:
		bird_resource = BirdResource.new() as Resource

	connect_to(bird_resource)


func execute() -> void:
	owner.register_bird(bird_resource as BirdResource)


func connect_to(node: Object) -> void:
	_connect_to_signal(node, "picked")


func _connect_to_signal(node: Object, signal_name: String) -> void:
	if node.has_signal(signal_name):
		node.connect(
			signal_name,
			self, "emit_signal", [signal_name],
			CONNECT_DEFERRED
		)
