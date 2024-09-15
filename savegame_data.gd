extends Node

var raw_header: PackedByteArray
var raw_irrelevant1: PackedByteArray
var raw_savegame_name: PackedByteArray
var savegame_name: String
var raw_irrelevant2: PackedByteArray
var raw_player_country_number: PackedByteArray
var player_country_number: int
var raw_player_country_name: PackedByteArray
var player_country_name: String
var raw_irrelevant3: PackedByteArray
var raw_country_names: PackedByteArray
var country_names: Array[String]
var raw_irrelevant4: PackedByteArray
var raw_map_key_length: PackedByteArray
var raw_map_key: PackedByteArray
var map_key: String
var raw_tile_data: Array[PackedByteArray]
var raw_irrelevant5: PackedByteArray
var raw_cities_data: Array[PackedByteArray]
var raw_irrelevant6: PackedByteArray

func format_data() -> void:
	savegame_name = raw_savegame_name.get_string_from_ascii()
	player_country_number = raw_player_country_number[0]
	player_country_name = raw_player_country_name.get_string_from_ascii()
	var index := 0
	for i in range(SavegameFormat.COUNTRIES_COUNT):
		var name_length := raw_country_names[index]
		var raw_country_name := raw_country_names.slice(index + 1, index + 1 + name_length)
		country_names.append(raw_country_name.get_string_from_ascii().trim_prefix(" "))
		index += 1 + name_length
	map_key = raw_map_key.get_string_from_ascii()

func clear_data() -> void:
	raw_header = PackedByteArray()
	raw_irrelevant1 = PackedByteArray()
	raw_savegame_name = PackedByteArray()
	savegame_name = ""
	raw_irrelevant2 = PackedByteArray()
	raw_player_country_number = PackedByteArray()
	player_country_number = 0
	raw_player_country_name = PackedByteArray()
	player_country_name = ""
	raw_irrelevant3 = PackedByteArray()
	raw_country_names = PackedByteArray()
	country_names = []
	raw_map_key_length = PackedByteArray()
	raw_map_key = PackedByteArray()
	map_key = ""
	raw_irrelevant4 = PackedByteArray()
	raw_tile_data = []
	raw_irrelevant5 = PackedByteArray()
	raw_cities_data = []
	raw_irrelevant6 = PackedByteArray()