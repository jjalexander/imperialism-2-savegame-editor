extends ScrollContainer

func set_header_info(raw_player_country_name: PackedByteArray, raw_map_key: PackedByteArray, number_of_tiles: int, number_of_cities: int) -> void:
	$general/header_table/player_country_name.text = raw_player_country_name.get_string_from_ascii()
	$general/header_table/map_generation_key.text = raw_map_key.get_string_from_ascii()
	$general/header_table/number_of_tiles.text = str(number_of_tiles)
	$general/header_table/number_of_cities.text = str(number_of_cities)

func set_countries_info(raw_country_names: Array[PackedByteArray]) -> void:
	for i in range(raw_country_names.size()):
		var country_name := raw_country_names[i].get_string_from_ascii().trim_prefix(' ')
		var country_label := Label.new()
		country_label.text = country_name
		$general/country_table.add_child(country_label)

		if i < 6:
			var reveal_button := Button.new()
			reveal_button.text = "Reveal map"
			reveal_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			$general/country_table.add_child(reveal_button)
			var hide_button := Button.new()
			hide_button.text = "Hide map"
			hide_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			$general/country_table.add_child(hide_button)
			var resources_button := Button.new()
			resources_button.text = "Reveal resources"
			resources_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			$general/country_table.add_child(resources_button)
		else:
			var reveal_node := Control.new()
			reveal_node.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			$general/country_table.add_child(reveal_node)
			var hide_node := Control.new()
			hide_node.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			$general/country_table.add_child(hide_node)
			var resources_node := Control.new()
			resources_node.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			$general/country_table.add_child(resources_node)
