extends TextureRect
#stub.
var ch_id = ""

func _ready():
	pass # Replace with function body.


func build_for_hero(hero):
	ch_id = hero


func build_for_fighter(fighter):
	ch_id = fighter
	$Label.text = ""
	var person = state.heroes[ch_id]
	var data = person.get_resists()
	for res in data:
		$Label.text += "%s: %.1f\n" % [res, data[res]]
