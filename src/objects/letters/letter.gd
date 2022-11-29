extends Selectable

signal received()
signal opened()
signal closed()

var _letter : LetterResource
var _drag_zone_tl : Vector2
var _drag_zone_br : Vector2

export var neat_texture : Texture
export var royal_texture : Texture
export var weathered_texture : Texture


func setup(letter: LetterResource, drag_zone: Rect2) -> void:
	_drag_zone_tl = drag_zone.position
	_drag_zone_br = _drag_zone_tl + drag_zone.size
	_letter = letter
	id = _letter.letter_id
	$Sprite.texture = _get_letter_texture(letter.letter_type)
	_letter.connect_to(self)


func get_name_when_selected() -> String:
	return _letter.letter_name if _letter.has_been_opened() else "???"


func is_draggable() -> bool:
	return true


func drag_to(position: Vector2) -> void:
	self.global_position = Vector2(
		clamp(position.x, _drag_zone_tl.x, _drag_zone_br.x),
		clamp(position.y, _drag_zone_tl.y, _drag_zone_br.y)
	)


func to_message(message_box: Node) -> void:
	message_box.set_contents(_letter.letter_contents)
	message_box.set_type(_letter.letter_type)


func _get_letter_texture(letter_type: int) -> Texture:
	match letter_type:
		LetterResource.Type.Neat: return neat_texture
		LetterResource.Type.Royal: return royal_texture
		LetterResource.Type.Weathered: return weathered_texture
	return null
