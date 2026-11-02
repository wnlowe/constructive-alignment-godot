extends Label


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
		self.text = "\n".join(files)
	else:
		self.text = "No Files Found"
		return
	
	var file = FileAccess.open(path.path_join(files[0]), FileAccess.READ)
	if not file:
		print("Cannot Open File: %s", file.get_open_error())
		return
	print(file.get_as_text())
