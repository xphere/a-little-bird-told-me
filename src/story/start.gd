extends Node


func trigger() -> void:
	var letter = owner.register_letter($"letter#1")
	var letter_at_desk : Node = owner.move_letter_to_mail_desk(letter)
	letter_at_desk.connect("closed", self, "_on_letter_closed", [], CONNECT_DEFERRED | CONNECT_ONESHOT)
	owner.to_state("MailDesk")


func _on_letter_closed() -> void:
	owner.to_state("Tower")
