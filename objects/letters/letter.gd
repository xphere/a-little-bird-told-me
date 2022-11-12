extends Node

export var letter_name : String
export(String, MULTILINE) var letter_content : String


func select(value: bool) -> void:
	var shader_material : ShaderMaterial = $Sprite.material
	shader_material.set_shader_param("enabled", value)
