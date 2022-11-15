extends CanvasItem

signal completed()


onready var _content := $"Content/Text/Label" as Label
onready var _speaker := $"Speaker/Text/Label" as Label


var _characters_shown : float
var _characters_per_sec : float


func info(content: String) -> void:
	visible = true
	_speaker.text = ""
	$Speaker.visible = false
	_content.text = content
	_content.visible_characters = -1
	$Content.theme_type_variation = "PanelContainerInformation"


func dialog(content: String, speaker: String, characters_per_sec: float) -> void:
	visible = true
	_characters_shown = 0
	_characters_per_sec = characters_per_sec
	_speaker.text = speaker
	$Speaker.visible = true
	_content.text = content
	_content.visible_characters = 0
	$Content.theme_type_variation = ""
	set_process(true)
	yield(self, "completed")
	yield(get_tree().create_timer(1.0), "timeout")
	visible = false


func _process(delta: float) -> void:
	if _content.percent_visible < 1.0:
		_characters_shown += _characters_per_sec * delta
		_content.visible_characters = round(_characters_shown)
	else:
		set_process(false)
		if _characters_shown > 0:
			emit_signal("completed")
