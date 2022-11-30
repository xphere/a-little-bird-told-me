extends CanvasItem

signal completed()

const MAX_CHARACTERS_PER_SECOND = 1024

onready var _content := $"%Content/Text/Label" as Label
onready var _speaker := $"%Speaker/Text/Label" as Label


var _is_alpha := RegEx.new()
var _last_visible_character := 0
var _characters_shown : float
var _characters_per_sec : float
var _shown : int = 0


func _ready() -> void:
	set_process(false)
	_is_alpha.compile("[a-zA-Z]")


func show() -> void:
	_shown += 1
	if _shown > 0:
		.show()


func hide() -> void:
	_shown -= 1
	if _shown <= 0:
		.hide()


func info(content: String, wait_input := false) -> void:
	_characters_per_sec = MAX_CHARACTERS_PER_SECOND
	_speaker.text = ""
	$"%Speaker".visible = false
	$"%Continue".visible = false
	_content.text = content
	_content.visible_characters = -1
	$"%Content".theme_type_variation = "PanelContainerInformation"
	show()
	if wait_input:
		yield(_wait_input(), "completed")


func dialog(content: String, speaker: String, characters_per_sec: float) -> void:
	_characters_shown = 0
	_characters_per_sec = characters_per_sec
	_speaker.text = speaker
	$"%Speaker".visible = true
	$"%Continue".visible = false
	_content.text = content
	_content.visible_characters = 0
	_last_visible_character = -1
	$"%Content".theme_type_variation = ""
	show()
	yield(_wait_input(), "completed")


func _wait_input() -> void:
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
		return

	_characters_shown += _characters_per_sec * delta# * 0.05
	_content.visible_characters = round(_characters_shown)

	if $"%Speaker".visible:
		_ticking_voice()


func _ticking_voice() -> void:
	if _last_visible_character >= _content.visible_characters:
		return

	if _content.visible_characters >= _content.text.length():
		return

	_last_visible_character = _content.visible_characters
	if _is_alpha.search(_content.text[_content.visible_characters]):
		$Talking.play()


func _input(event: InputEvent) -> void:
	var mouse_event := event as InputEventMouseButton
	if not mouse_event or not mouse_event.is_pressed():
		return

	if mouse_event.button_index != BUTTON_LEFT:
		return

	if not visible:
		set_process_input(false)
		return

	get_tree().set_input_as_handled()

	if _is_fully_shown():
		emit_signal("completed")
	else:
		_characters_per_sec = MAX_CHARACTERS_PER_SECOND
