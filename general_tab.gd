extends ScrollContainer

func set_header_info(raw_player_country_name: PackedByteArray, raw_map_key: PackedByteArray, number_of_tiles: int, number_of_cities: int) -> void:
	%player_country_name.text = raw_player_country_name.get_string_from_ascii()
	%map_generation_key.text = raw_map_key.get_string_from_ascii()
	%number_of_tiles.text = str(number_of_tiles)
	%number_of_cities.text = str(number_of_cities)

func set_countries_info(raw_country_names: Array[PackedByteArray]) -> void:
	for i in range(raw_country_names.size()):
		var country_name := raw_country_names[i].get_string_from_ascii().trim_prefix(' ')
		var country_label := Label.new()
		country_label.text = country_name
		country_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		country_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		country_label.set_custom_minimum_size(Vector2(0,35))
		%country_table.add_child(country_label)

		if i < 6:
			var reveal_button := Button.new()
			reveal_button.text = "Reveal map"
			reveal_button.size_flags_horizontal = Control.SIZE_FILL
			reveal_button.set_custom_minimum_size(Vector2(0,35))
			%country_table.add_child(reveal_button)
			var hide_button := Button.new()
			hide_button.text = "Hide map"
			hide_button.size_flags_horizontal = Control.SIZE_FILL
			%country_table.add_child(hide_button)
			var resources_button := Button.new()
			resources_button.text = "Reveal resources"
			resources_button.size_flags_horizontal = Control.SIZE_FILL
			%country_table.add_child(resources_button)
