extends Selectable

var bird_resource : Resource


func setup(bird: Resource) -> void:
	bird_resource = bird
	$Sprite.frame = bird.type
