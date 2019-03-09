extends Reference

var code;
var damagetype;
var skilltype;
var tags;
var value;
var manacost;
var casteffects;

var chance;
var evade;
var caster;
var target;
var critchance;
var hit_res;


func _init(c,t):
	caster = c;
	target = t;

func createfromskill(s_code):
	var ref = Skillsdata.skilllist[s_code];
	code = s_code;
	damagetype = ref.damagetype;
	skilltype = ref.skilltype;
	tags = ref.tags.duplicate();
	manacost = ref.manacost;
	casteffects = ref.casteffects.duplicate();
	if ref.has('chance'):
		chance = ref.chance;
	else:
		chance = caster.hitrate;
	if ref.has('critchance'):
		critchance = ref.critchance;
	else:
		critchance = caster.critchance;
	if ref.has('evade'):
		evade = ref.evade;
	else:
		evade = target.evasion;
	pass


func hit_roll():
	var prop = chance - evade;
	if prop < randf()*100:
		hit_res = variables.RES_MISS;
	elif critchance < randf()*100:
		hit_res = variables.RES_HIT;
	else:
		hit_res = variables.RES_CRIT;
	pass

func apply_atomic(effect):
	var tmp;
	if typeof(effect) == TYPE_STRING:
		tmp = Effectdata.atomic[effect];
	else:
		tmp = effect.duplicate();
	match tmp.type:
		'param':
			set(tmp.stat, get(tmp.stat) + tmp.value);
			pass
		'param_m':
			set(tmp.stat, get(tmp.stat) * tmp.value);
			pass
	pass

func apply_effect(code):
	var tmp = Effectdata.effect_table[code];
	var rec;
	var res;
	for cond in tmp.conditions:
		match cond.target:
			'skill':
				match cond.check:
					'type': res = res and (skilltype == cond.value);
					'tag': res = res and tags.has(cond.value);
					'result': res = res and (hit_res & cond.value != 0);
			'caster':
				res = res and input_handler.requirementcombatantcheck(cond.value, caster);
			'target':
				res = res and input_handler.requirementcombatantcheck(cond.value, target);
	if !res: return;
	for ee in tmp.effects:
			var eee;
			if typeof(ee) == TYPE_STRING: eee = Effectdata.atomic[ee].duplicate();
			else: eee = ee.duplicate();
			#convert effect to constant form
			if eee.type == 'skill':
				eee.type = eee.new_type;
				eee.value = get(eee.value) * eee.mul;
				pass
			match eee.target:
				'caster':
					rec = caster;
				'target':
					rec = target;
				'skill':
					rec = self;
			rec.apply_atomic(eee);
	pass
