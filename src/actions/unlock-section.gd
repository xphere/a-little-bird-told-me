class_name ActionUnlockSection
extends Action

enum Type {
	Recipient,
	Topic,
	Closing,
	Signature,
}

export(Type) var type : int
export var key : String
export var unlock := true
export var notify := true


func execute() -> void:
	match type:
		Type.Recipient: owner.set_recipient(key, unlock, notify)
		Type.Topic: owner.set_topic(key, unlock, notify)
		Type.Closing: owner.set_closing(key, unlock, notify)
		Type.Signature: owner.set_signature(key, unlock, notify)
