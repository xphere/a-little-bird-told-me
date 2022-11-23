class_name StringUtils
extends Object

const FLAG_SEP = ";"


static func is_flag_set(value: String, flag: String) -> bool:
	return (value + FLAG_SEP).find(FLAG_SEP + flag + FLAG_SEP) >= 0


static func set_flag(value: String, flag: String) -> String:
	return value if is_flag_set(value, flag) else (
		value + FLAG_SEP + flag
	)


static func flag_count(value: String) -> int:
	return value.count(FLAG_SEP)


static func replace_all_with_match(subject: String, rx: RegEx) -> String:
	while true:
		var rxm := rx.search(subject)
		if not rxm:
			break
		subject.erase(rxm.get_start(), rxm.get_string(0).length())
		subject = subject.insert(rxm.get_start(), rxm.get_string(1))

	return subject
