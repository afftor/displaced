extends ai_base

var turn = 0
var treant_summoned = false

func get_spec_data():
	var batt = input_handler.combat_node.enemygroup
	var res = 0
	for ch in batt.values():
		if ch.base == 'treant': res += 1
	return res

func bind(ch):
	.bind(ch)
	input_handler.combat_node.connect("turn_started", self, "turn_counter")

func turn_counter():
	turn += 1

func _get_action(hide_ignore = false):
	var action = ._get_action(hide_ignore)
	if treant_summoned :
		return action
	
	if turn >= 2:
		action = 'treant_summon'
	if action == 'treant_summon':
		treant_summoned = true
		input_handler.combat_node.disconnect("turn_started", self, "turn_counter")
	return action



