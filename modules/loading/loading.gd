extends Control

export(float, 0.0, 16.0, 0.001) var after := 0.0
export(float, 0.1, 16.0, 0.01) var threshold := 0.25
export var max_dots := 3

onready var _timer := $Timer
onready var _animation_player := $AnimationPlayer
onready var _text := $Container/Text

var _content : String
var _update := 0.0


func _ready() -> void:
	set_physics_process(false)
	_content = _text.text.trim_suffix("...")
	_timer.connect("timeout", self, "_do_show")
	hide()


func _physics_process(delta: float) -> void:
	_update += delta
	if _update > threshold:
		_update -= threshold
		_set_dot_count(_dot_count() + 1)


func start() -> void:
	if not _timer.is_stopped():
		return

	if after > 0.0:
		_timer.start(after)
	else:
		_do_show()


func stop() -> void:
	_timer.stop()
	_animation_player.queue("hide")
	yield(_animation_player, "animation_finished")
	set_physics_process(false)


func _do_show() -> void:
	_set_dot_count(max_dots)
	set_physics_process(true)
	_animation_player.queue("show")


func _dot_count() -> int:
	return _text.text.length() - _content.length()


func _set_dot_count(number: int) -> void:
	_text.text = _content + ".".repeat(number % (max_dots + 1))
