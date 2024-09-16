extends Panel

func set_country(i: int) -> void:
	$index/index_number.text = str(i)
	$name.text = SavegameData.country_names[i]
	$index.self_modulate = Ui.COUNTRY_COLORS[clamp(i, 0, Ui.COUNTRY_COLORS.size() - 1)]