extends Panel

func set_country(i: int) -> void:
	$ColorRect/Label.text = str(i)
	$Label.text = SavegameData.country_names[i]
	$ColorRect.color = Ui.COUNTRY_COLORS[clamp(i, 0, Ui.COUNTRY_COLORS.size() - 1)]
