extends Selectable

var bird_resource : BirdResource

var _sounds_node : Node


func setup(bird: BirdResource) -> void:
	bird_resource = bird
	id = id % bird.name
	$Sprite.frame = bird.type
	match bird.type:
		BirdResource.BirdType.CANARY: _sounds_node = $Sounds/Canary
		BirdResource.BirdType.ROBIN: _sounds_node = $Sounds/Robin


func _ready() -> void:
	if _sounds_node:
		_chirp()


func _chirp() -> void:
	var index := randi() % _sounds_node.get_child_count()
	var sound := _sounds_node.get_child(index) as AudioStreamPlayer
	sound.play()

	get_tree().create_timer(
		rand_range(5.0, 10.0)
	).connect("timeout", self, "_chirp")
