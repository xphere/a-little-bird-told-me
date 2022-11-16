extends CanvasItem

signal completed()


onready var _content := $"%Content/Text/Label" as Label
onready var _speaker := $"%Speaker/Text/Label" as Label


var _characters_shown : float
var _characters_per_sec : float
var _shown : int = 0


func _ready() -> void:
	set_process(false)


func show() -> void:
	_shown += 1
	if _shown > 0:
		.show()


func hide() -> void:
	_shown -= 1
	if _shown <= 0:
		.hide()


func info(content: String) -> void:
	_speaker.text = ""
	$"%Speaker".visible = false
	$"%Continue".visible = false
	_content.text = content
	_content.visible_characters = -1
	$"%Content".theme_type_variation = "PanelContainerInformation"
	show()


func dialog(content: String, speaker: String, characters_per_sec: float) -> void:
	_characters_shown = 0
	_characters_per_sec = characters_per_sec
	_speaker.text = speaker
	$"%Speaker".visible = true
	$"%Continue".visible = false
	_content.text = content
	_content.visible_characters = 0
	$"%Content".theme_type_variation = ""
	show()
	set_process(true)
	set_process_input(true)
	yield(self, "completed")
	set_process_input(false)
	set_process(false)
	hide()


func _is_fully_shown() -> bool:
	return _content.percent_visible >= 1.0


func _process(delta: float) -> void:
	if _is_fully_shown():
		set_process(false)
		$"%Continue".visible = true
	else:
		_characters_shown += _characters_per_sec * delta
		_content.visible_characters = round(_characters_shown)


func _input(event: InputEvent) -> void:
	var mouse_event := event as InputEventMouseButton
	if not mouse_event or not mouse_event.is_pressed():
		return

	if mouse_event.button_index != BUTTON_LEFT:
		return

	if _is_fully_shown():
		emit_signal("completed")
	else:
		_characters_per_sec = 1024
