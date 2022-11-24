class_name Selectable
extends Node

export var id : String


func _enter_tree() -> void:
	if Engine.editor_hint:
		return
	owner = NodeUtils.top_owner(self)


func select(value: bool) -> void:
	var shader_material : ShaderMaterial = $Sprite.material
	shader_material.set_shader_param("enabled", value)
