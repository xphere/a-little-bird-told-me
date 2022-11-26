extends Selectable

export var BirdScene : PackedScene

var _birds := []
var _current_bird : BirdResource
var _bird_node : Node


func select(value: bool) -> void:
	.select(value)
	if has_bird():
		_bird_node.select(value)


func has_bird() -> bool:
	return _current_bird != null


func get_bird() -> BirdResource:
	return _current_bird


func pickup_bird() -> BirdResource:
	var bird := _current_bird

	if _current_bird:
		_current_bird = null

	if _bird_node and is_instance_valid(_bird_node):
		_bird_node.queue_free()
	_bird_node = null

	return bird


func queue_bird(bird: BirdResource) -> void:
	_birds.push_back(bird)


func update_bird_queue() -> BirdResource:
	if _current_bird and is_instance_valid(_current_bird):
		return null

	_current_bird = null
	if _birds.empty():
		return null

	_current_bird = _birds.pop_front()
	_bird_node = BirdScene.instance()
	_bird_node.setup(_current_bird)
	$Bird.add_child(_bird_node)

	return _current_bird
