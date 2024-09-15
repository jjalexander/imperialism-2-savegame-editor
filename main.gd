extends Panel

class Country:
	var name: String
	
	func _to_string() -> String:
		return "Country(%s)" % name

class Field:
	var row: int
	var col: int
	var raw_data: PackedByteArray

	func _to_string() -> String:
		return "Field(%d, %d)" % [row, col]
 
var file_dialog_scene := preload("res://file_dialog.tscn")
var file_dialog: FileDialog

var general_scene := preload("res://general_tab.tscn")

func _ready() -> void:
	get_window().set_min_size(get_window().get_contents_minimum_size())

func _on_open_savegame_pressed() -> void:
	file_dialog = file_dialog_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	file_dialog.set_current_dir("C:/Program Files (x86)/GOG Galaxy/Games/Imperialism II/Save")
	file_dialog.connect("file_selected", _on_savegame_selected)
	add_child(file_dialog)

func _on_savegame_selected(path: String) -> void:
	file_dialog.queue_free()
	
	clear_ui()
	
	var input: PackedByteArray = FileAccess.get_file_as_bytes(path)
	
	SavegameData.clear_data()

	SavegameData.raw_header = get_pba_between(input, SavegameFormat.HEADER_START, SavegameFormat.HEADER_START + SavegameFormat.HEADER_LENGTH)
	if SavegameData.raw_header.get_string_from_ascii() != SavegameFormat.HEADER:
		%savegame_location.text = "Invalid file: %s" % [path]
		SavegameData.clear_data()
		return

	SavegameData.raw_irrelevant1 = get_pba_between(input, SavegameFormat.HEADER_START + SavegameFormat.HEADER_LENGTH, SavegameFormat.SAVENAME_START)
	SavegameData.raw_savegame_name = get_pba_between(input, SavegameFormat.SAVENAME_START, SavegameFormat.SAVENAME_START + SavegameFormat.SAVENAME_MAX_LENGTH)
	SavegameData.raw_irrelevant2 = get_pba_between(input, SavegameFormat.SAVENAME_START + SavegameFormat.SAVENAME_MAX_LENGTH, SavegameFormat.PLAYER_COUNTRY_NUMBER)
	SavegameData.raw_player_country_number = get_pba_between(input, SavegameFormat.PLAYER_COUNTRY_NUMBER, SavegameFormat.PLAYER_COUNTRY_NUMBER + 1)
	SavegameData.raw_player_country_name = get_pba_between(input, SavegameFormat.PLAYER_COUNTRY_NAME_START, SavegameFormat.PLAYER_COUNTRY_NAME_START + SavegameFormat.PLAYER_COUNTRY_NAME_LENGTH)
	SavegameData.raw_irrelevant3 = get_pba_between(input, SavegameFormat.PLAYER_COUNTRY_NAME_START + SavegameFormat.PLAYER_COUNTRY_NAME_LENGTH, SavegameFormat.COUNTRY_NAMES_START)
	
	var index := SavegameFormat.COUNTRY_NAMES_START
	for i in range(SavegameFormat.COUNTRIES_COUNT):
		var raw_name_length := get_pba_between(input, index, index + 1)
		var name_length := raw_name_length[0]
		index += 1 + name_length
	SavegameData.raw_country_names = get_pba_between(input, SavegameFormat.COUNTRY_NAMES_START, index)
	
	var world_data_start := get_world_data_start(input)
	if world_data_start == -1:
		%savegame_location.text = "Invalid file: %s" % [path]
		SavegameData.clear_data()
		return
	SavegameData.raw_irrelevant4 = get_pba_between(input, index, world_data_start)
	SavegameData.raw_map_key_length = get_pba_between(input, world_data_start, world_data_start + 1)
	var map_key_length := SavegameData.raw_map_key_length[0]
	SavegameData.raw_map_key = get_pba_between(input, world_data_start + 1, world_data_start + 1 + map_key_length)
	var tile_data_start := world_data_start + 1 + map_key_length
	for i in range(SavegameFormat.WORLD_SIZE):
		SavegameData.raw_tile_data.push_back(get_pba_between(input, tile_data_start + i * SavegameFormat.TILE_DATA_LENGTH, tile_data_start + (i + 1) * SavegameFormat.TILE_DATA_LENGTH))
	var tile_data_end := tile_data_start + SavegameFormat.WORLD_SIZE * SavegameFormat.TILE_DATA_LENGTH
	SavegameData.raw_irrelevant5 = get_pba_between(input, tile_data_end, tile_data_end + 1)

	index = tile_data_end + 1
	while input[index] != 255 and input[index + 1] != 255:
		var city_name_length := input[index + SavegameFormat.CITY_DATA_LENGTH - 1]
		SavegameData.raw_cities_data.push_back(get_pba_between(input, index, index + SavegameFormat.CITY_DATA_LENGTH + city_name_length))
		index += SavegameFormat.CITY_DATA_LENGTH + city_name_length
	SavegameData.raw_irrelevant6 = get_pba_between(input, index, index + 2)

	SavegameData.format_data()

	%savegame_location.text = "{path} ({name})".format({"path": path, "name": SavegameData.raw_savegame_name.get_string_from_ascii()})	
	%General.add_child(general_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED))
	
func get_world_data_start(input: PackedByteArray) -> int:
	var start_marker := SavegameFormat.WORLD_DATA_START_MARKER
	var start_index := -1
	for i in range(input.size() - 4):
		var slice := input.slice(i, i + 5)
		if slice == start_marker:
			start_index = i
			break
	return start_index + 19

func get_pba_between(input: PackedByteArray, start: int, end: int) -> PackedByteArray:
	return input.slice(start, end)

func clear_ui() -> void:
	%savegame_location.text = ""
	for child in %General.get_children():
		child.queue_free()
