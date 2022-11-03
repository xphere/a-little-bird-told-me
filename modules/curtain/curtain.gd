extends CanvasItem

signal finished

export var duration := 1.0

onready var _material := material as ShaderMaterial

var _is_down := false
var _moving := false


func _ready() -> void:
	_is_down = _get_material_threshold() >= 1.0


func down() -> void:
	if _moving:
		yield(self, "finished")

	if _is_down:
		call_deferred("_done")
		yield(self, "finished")
		return

	_material.set_shader_param("inverted", false)
	hide()
	call_deferred("show")
	yield(_transition(0.0, 1.0), "finished")
	_is_down = true
	_done()


func up() -> void:
	if _moving:
		yield(self, "finished")

	if not _is_down:
		call_deferred("_done")
		yield(self, "finished")
		return

	_material.set_shader_param("inverted", true)
	call_deferred("show")
	yield(_transition(1.0, 0.0), "finished")
	_is_down = false
	hide()
	_done()


func _set_material_threshold(value: float) -> void:
	_material.set_shader_param("amount", value)


func _get_material_threshold() -> float:
	return _material.get_shader_param("amount")


func _transition(from: float, to: float) -> SceneTreeTween:
	_moving = true
	_set_material_threshold(from)
	var tween := create_tween()
	tween.tween_method(self, "_set_material_threshold", from, to, duration)
	return tween


func _done() -> void:
	_moving = false
	emit_signal("finished")
