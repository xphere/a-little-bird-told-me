extends Control


func on_enter() -> void:
	var contents : String = owner.context("letter.contents")
	$"%MessageBox".set_contents(contents)
	show()


func on_leave() -> void:
	hide()


func _on_Back_pressed() -> void:
	owner.pop_state()
