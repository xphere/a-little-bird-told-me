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


func execute() -> void:
	match type:
		Type.Recipient: owner.set_recipient(key, unlock)
		Type.Topic: owner.set_topic(key, unlock)
		Type.Closing: owner.set_closing(key, unlock)
		Type.Signature: owner.set_signature(key, unlock)
