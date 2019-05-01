extends Node

func _ready():
	pass # Replace with function body.

var effects: = {}

func get_new_id():
	var s := "eid%d"
	var t = randi()
	while effects.has(s % t):
		t += 1
	return s % t


func add_effect(eff:base_effect):
	var id = get_new_id()
	effects[id] = eff
	return id

func add_stored_effect(id, eff:base_effect):
	effects[id] = eff

func get_effect_by_id(id):
	return effects[id]

func serialize():
	var tmp = {}
	for e in effects.keys():
		tmp[e] = effects[e].serialize()
	return tmp

static func deserialize_effect(tmp, caller):
	var eff
	match tmp.type:
		'base':
			eff = base_effect.new(caller)
	eff.deserialize(tmp)
	return eff

func deserialize(tmp):
	effects.clear()
	for k in tmp.keys():
		var eff = deserialize_effect(tmp, null)
		effects[k] = eff