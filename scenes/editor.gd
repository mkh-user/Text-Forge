extends CodeEdit
class_name Editor

## Main editor node

## Returns char index in [param line] and [param column]
func get_char_index(line: int, column: int) -> int:
	var before = ""
	var counter = 0
	for i in text.split("\n", true, line):
		if counter < line:
			before += i + "\n"
		counter += 1
	return before.length() + column
