extends ScrollContainer

var country_scene := preload("res://country.tscn")

func _ready() -> void:
	%player_country.set_country(SavegameData.player_country_number)
	%map_generation_key.text = SavegameData.map_key
	%number_of_tiles.text = str(SavegameData.raw_tile_data.size())
	%number_of_cities.text = str(SavegameData.raw_cities_data.size())

	for i in range(SavegameData.country_names.size()):
		var country := country_scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
		country.set_country(i)
		%country_table.add_child(country)
		
		if i < 6:
			var reveal_button := Button.new()
			reveal_button.text = "Reveal map"
			reveal_button.size_flags_horizontal = Control.SIZE_FILL
			reveal_button.set_custom_minimum_size(Vector2(0, 35))
			%country_table.add_child(reveal_button)
			
			var hide_button := Button.new()
			hide_button.text = "Hide map"
			hide_button.size_flags_horizontal = Control.SIZE_FILL
			%country_table.add_child(hide_button)
			
			var resources_button := Button.new()
			resources_button.text = "Reveal resources"
			resources_button.size_flags_horizontal = Control.SIZE_FILL
			%country_table.add_child(resources_button)
