tool
extends Action

const BirdResource := preload("res://src/resources/bird.gd")

export(Resource) var bird_resource := BirdResource.new() as Resource


func execute() -> void:
	owner.register_bird(bird_resource as BirdResource)
