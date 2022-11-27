class_name Selectable
extends Node

export var id : String

var _player : AnimationPlayer


func _enter_tree() -> void:
	if Engine.editor_hint:
		return
	owner = NodeUtils.top_owner(self)


func select(value: bool) -> void:
	var shader_material : ShaderMaterial = $Sprite.material
	shader_material.set_shader_param("enabled", value)


func animate(name: String) -> void:
	if not _player:
		_player = $AnimationPlayer

	if not _player or not _player.has_animation(name):
		return

	if _player.is_playing() and not _is_in_a_loop(_player):
		yield(_player, "animation_finished")

	_player.play(name)


static func _is_in_a_loop(player: AnimationPlayer) -> bool:
	var current_animation := player.current_animation

	return player.get_animation(current_animation).loop
