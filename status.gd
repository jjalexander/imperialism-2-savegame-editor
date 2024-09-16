extends Label

# create a new stylebox
var stylebox := StyleBoxFlat.new()

func _ready() -> void:
	# set the text of the label to "Program opened"
	text = "Program opened"
	# set the background color of the label to green
	stylebox.bg_color = Color.DARK_GREEN
	# set the corner radius of the label to 10
	stylebox.set_corner_radius_all(5)
	# set the stylebox of the label to the new stylebox
	self.add_theme_stylebox_override("normal", stylebox)


func set_good_status(given_text: String) -> void:
	# set the text of the label to the given text
	text = given_text
	# set the background color of the label to green
	stylebox.bg_color = Color.DARK_GREEN


func set_bad_status(given_text: String) -> void:
	# set the text of the label to the given text
	text = given_text
	# set the background color of the label to red
	stylebox.bg_color = Color.DARK_RED