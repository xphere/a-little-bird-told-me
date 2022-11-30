class_name BirdResource
extends Resource

signal picked()

enum BirdType {
	CANARY,
	ROBIN,
	PIGEON,
	CROW,
}


export var name : String = ""
export var energy := 100
export var carries : Resource
export var is_known := false
export(BirdType) var type := BirdType.CANARY
