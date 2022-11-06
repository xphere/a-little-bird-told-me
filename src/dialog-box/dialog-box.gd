extends Node


onready var _content := $"Content/Text/Label" as Label
onready var _speaker := $"Speaker/Text/Label" as Label


func info(content: String) -> void:
	_speaker.text = ""
	$Speaker.visible = false
	_content.text = content
	$Content.theme_type_variation = "PanelContainerInformation"


func dialog(content: String, speaker: String) -> void:
	_speaker.text = speaker
	$Speaker.visible = true
	_content.text = content
	$Content.theme_type_variation = ""
