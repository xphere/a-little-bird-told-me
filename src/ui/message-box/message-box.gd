extends Node

const LetterResource := preload("res://src/resources/letter.gd")

export var highlight_topics := true


func _ready() -> void:
	owner = NodeUtils.top_owner(self)


func set_contents(contents: String) -> void:
	if not highlight_topics:
		var rx := RegEx.new()
		rx.compile("\\[url\\b.*?\\](.+)\\[/url]")
		contents = StringUtils.replace_all_with_match(contents, rx)
	$"%Text".bbcode_text = contents


func set_type(type: int) -> void:
	$Texture/NeatTexture.visible = type == LetterResource.Type.Neat
	$Texture/RoyalTexture.visible = type == LetterResource.Type.Royal
	$Texture/WeatheredTexture.visible = type == LetterResource.Type.Weathered


func _on_Label_meta_clicked(meta) -> void:
	owner.discover(meta)
