class_name ActionPlanAction
extends Action

export var in_steps := 1
export var action_path : NodePath


func execute() -> void:
	var action := _find_action(action_path) as Action
	if action:
		owner.plan_action(in_steps, action)


func _find_action(path: NodePath) -> Node:
	if not action_path.is_empty():
		return get_node(path)

	if get_child_count() > 0:
		return get_child(0)

	return null
