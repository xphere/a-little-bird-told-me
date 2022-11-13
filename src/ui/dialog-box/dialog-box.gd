extends CanvasItem


onready var _content := $"Content/Text/Label" as Label
onready var _speaker := $"Speaker/Text/Label" as Label


func info(content: String) -> void:
	visible = true
	_speaker.text = ""
	$Speaker.visible = false
	_content.text = content
	_content.visible_characters = -1
	$Content.theme_type_variation = "PanelContainerInformation"


func dialog(content: String, speaker: String) -> void:
	visible = true
	if get_tree().is_connected("idle_frame", self, "_on_idle_frame"):
		get_tree().disconnect("idle_frame", self, "_on_idle_frame")
	_speaker.text = speaker
	$Speaker.visible = true
	_content.text = content
	_content.visible_characters = 0
	$Content.theme_type_variation = ""
	_on_idle_frame()


func _on_idle_frame() -> void:
	if _content.percent_visible < 1.0:
		_content.visible_characters += 1
		get_tree().connect("idle_frame", self, "_on_idle_frame", [], CONNECT_ONESHOT | CONNECT_DEFERRED)
