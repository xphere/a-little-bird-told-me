extends Selectable

var bird_resource : BirdResource


func setup(bird: BirdResource) -> void:
	bird_resource = bird
	$Sprite.frame = bird.type
