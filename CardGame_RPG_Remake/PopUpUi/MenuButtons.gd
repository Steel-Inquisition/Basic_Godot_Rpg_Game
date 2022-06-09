extends MenuButton

func add_these_times(all_attacks):
	for i in all_attacks.size():
		get_popup().add_item(all_attacks[i].attack_name)
