extends Resource

enum BirdType {
	CANARY,
	PIGEON,
	ROBIN,
}


export var name : String = ""
export var energy := 100
export var carries : Resource
export var is_known := false
export(BirdType) var type := BirdType.CANARY
