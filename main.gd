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

var raw_header: PackedByteArray
var raw_irrelevant1: PackedByteArray
var raw_savegame_name: PackedByteArray
var raw_irrelevant2: PackedByteArray
var raw_player_country_number: PackedByteArray
var raw_player_country_name: PackedByteArray
var raw_irrelevant3: PackedByteArray
var raw_country_name_lengths: Array[PackedByteArray]
var raw_country_names: Array[PackedByteArray]
var raw_map_key_length: PackedByteArray
var raw_map_key: PackedByteArray
var raw_irrelevant4: PackedByteArray
var raw_tile_data: Array[PackedByteArray]
var raw_irrelevant5: PackedByteArray
var raw_cities_data: Array[PackedByteArray]
var raw_irrelevant6: PackedByteArray

func _ready() -> void:
	get_window().set_min_size(get_window().get_contents_minimum_size())

func _on_open_savegame_pressed() -> void:
	file_dialog = file_dialog_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	file_dialog.set_current_dir("C:/Program Files (x86)/GOG Galaxy/Games/Imperialism II/Save")
	file_dialog.connect("file_selected", _on_savegame_selected)
	add_child(file_dialog)

func _on_savegame_selected(path: String) -> void:
	file_dialog.queue_free()
	
	var input: PackedByteArray = FileAccess.get_file_as_bytes(path)
	
	clear_data()

	raw_header = get_pba_between(input, Constants.HEADER_START, Constants.HEADER_START + Constants.HEADER_LENGTH)
	if raw_header.get_string_from_ascii() != Constants.HEADER:
		%savegame_location.text = "Invalid file: %s" % [path]
		clear_data()
		return

	raw_irrelevant1 = get_pba_between(input, Constants.HEADER_START + Constants.HEADER_LENGTH, Constants.SAVENAME_START)
	raw_savegame_name = get_pba_between(input, Constants.SAVENAME_START, Constants.SAVENAME_START + Constants.SAVENAME_MAX_LENGTH)
	raw_irrelevant2 = get_pba_between(input, Constants.SAVENAME_START + Constants.SAVENAME_MAX_LENGTH, Constants.PLAYER_COUNTRY_NUMBER)
	raw_player_country_number = get_pba_between(input, Constants.PLAYER_COUNTRY_NUMBER, Constants.PLAYER_COUNTRY_NUMBER + 1)
	raw_player_country_name = get_pba_between(input, Constants.PLAYER_COUNTRY_NAME_START, Constants.PLAYER_COUNTRY_NAME_START + Constants.PLAYER_COUNTRY_NAME_LENGTH)
	raw_irrelevant3 = get_pba_between(input, Constants.PLAYER_COUNTRY_NAME_START + Constants.PLAYER_COUNTRY_NAME_LENGTH, Constants.COUNTRY_NAMES_START)
	
	var index := Constants.COUNTRY_NAMES_START
	for i in range(Constants.COUNTRIES_COUNT):
		var raw_name_length := get_pba_between(input, index, index + 1)
		raw_country_name_lengths.push_back(raw_name_length)
		var name_length := raw_name_length[0]
		var raw_country_name := get_pba_between(input, index + 1, index + 1 + name_length)
		raw_country_names.push_back(raw_country_name)
		index += 1 + name_length
	
	var world_data_start := get_world_data_start(input)
	if world_data_start == -1:
		%savegame_location.text = "Invalid file: %s" % [path]
		clear_data()
		return
	raw_irrelevant4 = get_pba_between(input, index, world_data_start)
	raw_map_key_length = get_pba_between(input, world_data_start, world_data_start + 1)
	var map_key_length := raw_map_key_length[0]
	raw_map_key = get_pba_between(input, world_data_start + 1, world_data_start + 1 + map_key_length)
	var tile_data_start := world_data_start + 1 + map_key_length
	for i in range(Constants.WORLD_SIZE):
		raw_tile_data.push_back(get_pba_between(input, tile_data_start + i * Constants.TILE_DATA_LENGTH, tile_data_start + (i + 1) * Constants.TILE_DATA_LENGTH))
	var tile_data_end := tile_data_start + Constants.WORLD_SIZE * Constants.TILE_DATA_LENGTH
	raw_irrelevant5 = get_pba_between(input, tile_data_end, tile_data_end + 1)

	index = tile_data_end + 1
	while input[index] != 255 and input[index + 1] != 255:
		var city_name_length := input[index + Constants.CITY_DATA_LENGTH - 1]
		raw_cities_data.push_back(get_pba_between(input, index, index + Constants.CITY_DATA_LENGTH + city_name_length))
		index += Constants.CITY_DATA_LENGTH + city_name_length
	raw_irrelevant6 = get_pba_between(input, index, index + 2)

	%savegame_location.text = "{path} ({name})".format({"path": path, "name": raw_savegame_name.get_string_from_ascii()})
		
	for i in %General.get_children():
		i.queue_free()
	
	var general_table := general_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	general_table.set_header_info(raw_player_country_name,raw_map_key,raw_tile_data.size(),raw_cities_data.size())
	general_table.set_countries_info(raw_country_names)
	%General.add_child(general_table)
	
func get_world_data_start(input: PackedByteArray) -> int:
	var start_marker := Constants.WORLD_DATA_START_MARKER
	var start_index := -1
	for i in range(input.size() - 4):
		var slice := input.slice(i, i + 5)
		if slice == start_marker:
			start_index = i
			break
	return start_index + 19

func get_pba_between(input: PackedByteArray, start: int, end: int) -> PackedByteArray:
	return input.slice(start, end)

func clear_data() -> void:
	raw_header = PackedByteArray()
	raw_irrelevant1 = PackedByteArray()
	raw_savegame_name = PackedByteArray()
	raw_irrelevant2 = PackedByteArray()
	raw_player_country_number = PackedByteArray()
	raw_player_country_name = PackedByteArray()
	raw_irrelevant3 = PackedByteArray()
	raw_country_name_lengths = []
	raw_country_names = []
	raw_map_key_length = PackedByteArray()
	raw_map_key = PackedByteArray()
	raw_irrelevant4 = PackedByteArray()
	raw_tile_data = []
	raw_irrelevant5 = PackedByteArray()
	raw_cities_data = []
	raw_irrelevant6 = PackedByteArray()
