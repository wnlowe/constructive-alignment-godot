extends Label

signal cleaned_text(output_text)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_files(path: String) -> void:
	var files = []
	var dir = DirAccess.open(path)
	if dir:
		for file in dir.get_files():
			if file.ends_with(".md"):
				files.append(file)
		#self.text = "\n".join(files)
	else:
		self.text = "No Files Found"
		return
	
	if len(files) == 0:
		print("No .md files found")
		return
	var file = FileAccess.open(path.path_join(files[0]), FileAccess.READ)
	if not file:
		print("Cannot Open File: %s" % FileAccess.get_open_error())
		return
	
	var output_text = file.get_as_text()
	output_text = output_text.replace("[", "[lb]") 
	var regexes = {
		RegEx.create_from_string(r"\[lb\]([^\]]+)\]\(([^)]+)\)") : "[url=$2]$1[/url]",
		RegEx.create_from_string(r"(?m)^# (.+)$") : "[font_size=36][b]$1[/b][/font_size]",
		RegEx.create_from_string(r"(?m)^## (.+)$") : "[font_size=30][b]$1[/b][/font_size]",
		RegEx.create_from_string(r"(?m)^### (.+)$") : "[font_size=26][b]$1[/b][/font_size]",
		RegEx.create_from_string(r"(?m)^#### (.+)$") : "[font_size=22][b]$1[/b][/font_size]",
		RegEx.create_from_string(r"(?m)^##### (.+)$") : "[font_size=20][b]$1[/b][/font_size]",
		RegEx.create_from_string(r"(?m)^###### (.+)$") : "[font_size=18][b]$1[/b][/font_size]",
		RegEx.create_from_string(r"\*\*\*(.+?)\*\*\*") : "[b][i]$1[/i][/b]",
		RegEx.create_from_string(r"\*\*(.+?)\*\*") : "[b]$1[/b]",
		RegEx.create_from_string(r"\*(\S(?:[^*\n]*\S)?)\*") : "[i]$1[/i]",
		RegEx.create_from_string(r"~~(.+?)~~") : "[s]$1[/s]",
		RegEx.create_from_string(r"`([^`\n]+)`") : "[code]$1[/code]"
	}
	for regex in regexes:
		output_text = regex.sub(output_text, regexes[regex], true)
	print(output_text)
	cleaned_text.emit(output_text)
