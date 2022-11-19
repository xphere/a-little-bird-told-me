extends Node


func _ready() -> void:
	owner = NodeUtils.top_owner(self)


func set_contents(contents: String) -> void:
	$"%Text".bbcode_text = contents


func _on_Label_meta_clicked(meta) -> void:
	owner.discover(meta)
