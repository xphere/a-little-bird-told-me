extends Node

const LetterResource := preload("res://src/resources/letter.gd")


func _ready() -> void:
	owner = NodeUtils.top_owner(self)


func set_contents(contents: String) -> void:
	$"%Text".bbcode_text = contents


func set_type(type: int) -> void:
	$Texture/NeatTexture.visible = type == LetterResource.Type.Neat
	$Texture/RoyalTexture.visible = type == LetterResource.Type.Royal
	$Texture/WeatheredTexture.visible = type == LetterResource.Type.Weathered


func _on_Label_meta_clicked(meta) -> void:
	owner.discover(meta)
