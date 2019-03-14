extends Reference

var code;
var damagetype;
var damagesrc;
var skilltype;
var tags;
var value;
var long_value;
var manacost;
var casteffects;
var userange;

var chance;
var evade;
var caster;
var target;
var critchance;
var hit_res;
var armor_p;

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
	long_value = ref.value; 
	userange = ref.userange;
	casteffects = ref.casteffects.duplicate();
	if ref.keys().has('chance'):
		chance = ref.chance;
	else:
		chance = caster.hitrate;
	if ref.keys().has('critchance'):
		critchance = ref.critchance;
	else:
		critchance = caster.critchance;
	if ref.keys().has('evade'):
		evade = ref.evade;
	else:
		evade = target.evasion;
	if ref.keys().has('armor_p'):
		armor_p = ref['armor_p'];
	else:
		armor_p = caster.armorpenetration;
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

func apply_effect(code, trigger):
	var tmp = Effectdata.effect_table[code];
	var rec;
	var res;
	if tmp.trigger != trigger: return;
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
			'chance':
				res = res and (randf()*100 < cond.value);
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

func calculate_dmg():
	if damagetype == 'weapon':
		damagesrc = variables.S_PHYS;
	elif damagetype == 'fire':
		damagesrc = variables.S_FIRE
	elif damagetype == 'water':
		damagesrc = variables.S_WATER
	elif damagetype == 'air':
		damagesrc = variables.S_AIR
	elif damagetype == 'earth':
		damagesrc = variables.S_EARTH
	if hit_res == variables.RES_CRIT:
		value *= caster.critmod;
	var reduction = 0;
	if skilltype == 'skill':
		reduction = max(0, target.armor - armor_p)
	elif skilltype == 'spell':
		reduction = max(0, target.mdef)
	if !tags.has('heal'):
		value = value * (float(100 - reduction)/100);
	if damagetype in ['fire','water','air','earth']:
		value = value * ((100 - target['resist' + damagetype])/100);
