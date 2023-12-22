extends Control
#stub.
var ch_id = ""

func _ready():
	pass # Replace with function body.


#func build_for_hero(hero):
#	ch_id = hero


func build_for_fighter(fighter):
	ch_id = fighter
#	$Label.text = ""
	var person = state.heroes[ch_id]
	$icon.texture = person.combat_portrait()
	var data :Dictionary = person.get_resists().duplicate()#in fact get_resists() return unique dict for now, but it's better to duplicate it once more in case of future changes
	data.merge(person.get_s_resists())
	for container in $VBoxContainer.get_children():
		if !data.has(container.name):
			container.hide()
		else:
			container.show()
			container.get_node("ResistIcon").update_value(
				"%.1f" % data[container.name],
				data[container.name] > 0
			)
#	for res in data:
#		$Label.text += "%s: %.1f\n" % [res, data[res]]
