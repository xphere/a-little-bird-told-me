tool
class_name BirdRegisterAction, "bird.icon.png"
extends Action

export(Resource) var bird_resource := BirdResource.new() as Resource


func execute() -> void:
	owner.register_bird(bird_resource as BirdResource)
