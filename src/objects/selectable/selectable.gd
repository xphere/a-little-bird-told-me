class_name Selectable
extends Node


func select(value: bool) -> void:
	var shader_material : ShaderMaterial = $Sprite.material
	shader_material.set_shader_param("enabled", value)
