extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	var total_t = {}
	for mission in Explorationdata.areas.values():
		var code = mission.code
		if !mission.has('enemies'): continue
		for stage in mission.enemies:
			var data = mission.enemies[stage]
			var sloot = {}
			for w in data:
				for rec in w.values():
					var en_id = rec[0]
					var en_data = Enemydata.enemylist[en_id]
					if en_data.has('loottable') and en_data.loottable != '':
						var table = en_data.loottable
						add_loottable_data(sloot, {table : 1})
			var text = "[color=yellow]%s[/color] - [color=red]%d[/color] gain:\n {\n%s}\n" % [code, stage, dict2str(make_loot_t(sloot))]
			$Label.append_bbcode(text)
			add_loottable_data(total_t, sloot)
		var text = "[color=yellow]%s [/color] at mission end: {\n%s}" % [code, dict2str(make_loot_t(total_t))]
		$Label.append_bbcode(text)

func dict2str(dict):
	var res = ""
	for rs in dict:
		res += "[color=green]%s[/color] - %.2f (avg): %.2f - %.2f (reason), %.2f - %.2f (expected)\n" % [rs, dict[rs][0], dict[rs][1], dict[rs][2], dict[rs][3], dict[rs][4]]
	return res


func add_loottable_data(total, from):
	for res in from:
		if !total.has(res):
			total[res] = from[res]
		else:
			total[res] += from[res]


func add_loot_data(total, from):
	for res in from:
		if !total.has(res):
			total[res] = from[res]
		else:
			for i in range(5):
				total[res][i] += from[res][i]


func make_loot(en_list):
	var res = {}
	for en in en_list:
		add_loot_data(res, make_loot_data(en, en_list[en]))
	return res


func make_loot_t(table_list):
	var res = {}
	for en in table_list:
		var tt
		if typeof(en) == TYPE_STRING:
			tt = Enemydata.loottables[en]
		else:
			tt = en
		add_loot_data(res, make_loot_table(tt, table_list[en]))
	return res


func make_loot_table(table, amount):
	var res = {}
	if table != null and table.has('items'):
		table = table.items
		for rs in table:
			var p = rs.chance / 100.0
			var q = 1.0 - p
			var si = sqrt(amount * p * q)
			print(si)
			var m = amount * p
			res[rs.code] = [m, max(0.0, m - 3 * si), m + 3 * si, max(0.0, m - si), m + si]
	return res


func make_loot_data(en_id, amount):
	var res = {}
	var data = Enemydata.enemylist[en_id]
	var table = null
	if typeof(data.loottable) == TYPE_DICTIONARY:
		table = data.loottable
	elif Enemydata.loottables.has(data.loottable):
		table = Enemydata.loottables[data.loottable]
	return make_loot_table(table, amount)
