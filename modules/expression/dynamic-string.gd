class_name DynamicString
extends Resource

var _text := ""
var _expressions := []


static func is_dynamic(text: String) -> bool:
	return text.find("{{") >= 0


func _init(text: String) -> void:
	parse(text)


func evaluate(instance: Object, inputs: Array = []) -> String:
	var values := []
	for expression in _expressions:
		values.push_back(expression.execute(inputs, instance))

	return _text % values


func parse(text: String) -> void:
	_text = text
	_expressions = []
	if not is_dynamic(text):
		return

	var rx := RegEx.new()
	rx.compile("{{(.*?)}}")

	var offset := 0
	for result in rx.search_all(_text):
		offset = _parse_match(result, offset)


func _parse_match(result: RegExMatch, offset: int) -> int:
	var start : int = result.get_start()
	var length : int = result.get_end() - start

	_text.erase(start - offset, length)
	_text = _text.insert(start - offset, "%s")

	var expression := Expression.new()
	expression.parse(result.strings[1])
	_expressions.push_back(expression)

	return offset + length - 2
