extends Selectable

var bird_resource : BirdResource


func setup(bird: BirdResource) -> void:
	bird_resource = bird
	id = id % bird.name
	$Sprite.frame = bird.type
