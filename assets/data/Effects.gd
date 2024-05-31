extends Node
#warning! only short pathes in buffs section will be preloaded 

#templates
var e_dot_template = {
	type = 'trigger',
	trigger = [variables.TR_TURN_F],
	req_skill = false,
	conditions = [],
	args = [{obj = 'parent_args', param = 0}],
	sub_effects = [{
			type = 'oneshot',
			target = 'owner',
			args = [{obj = 'parent_args', param = 0}],
			atomic = [],
		}
	],
	buffs = []
}
#------------------

var effect_table = {
	#defence
	e_s_defence = {
		type = 'temp_s',
		screen_name = 'EF_DEFENCE',#all in all, temp effect with buffs should have screen_name
		name = 'defence',
		target = 'caster',
		stack = 1,
		tick_event = [],
		rem_event = variables.TR_TURN_S,
		tags = ['defence'],
		args = [],
		sub_effects = [],
		atomic = [{type = 'stat_add', stat = 'resistdamage', value = 50}],
		buffs = [{
			icon = "res://assets/images/iconsskills/action_2.png", 
			description = "BUFF_DEFENCE",
			limit = 1,
			t_name = 'icon_defence'
		}],
	},
	e_summon = {
		type = 'static',
		debug_name = 'summon',
		tags = ['summon'],
		args = [],
		sub_effects = [],
		atomic = [],
		buffs = [{
			icon = "res://assets/images/iconsskills/meditate.png",
			description = "BUFF_SUMMON",
			limit = 1,
			t_name = 'icon_summon'
		}],
	},
	#statuses
	e_s_burn = {
		type = 'temp_s',
		screen_name = 'EF_BURN',
		name = 'burn',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_F],
		duration = 2,
		tags = ['burn', 'negative'],
		icon_text = "BUFF_TURN_END",
		args = [
			{obj = 'parent_args', param = 0},
			{obj = 'template', param = 'icon_text'}],
		sub_effects = [rebuild_dot('a_burn'), rebuild_remove(['damagetype','eq', 'water'])],
		atomic = [],
		buffs = ['b_burn'],
	},
	e_s_burn_onget = {#same as e_s_burn, but triggered at TR_TURN_GET
		type = 'temp_s',
		screen_name = 'EF_BURN',
		name = 'burn_onget',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_GET],
		duration = 2,
		tags = ['burn', 'negative'],
		icon_text = "BUFF_TURN_BEGINNING",
		args = [
			{obj = 'parent_args', param = 0},
			{obj = 'template', param = 'icon_text'}],
		sub_effects = [rebuild_dot_onget('a_burn'), rebuild_remove(['damagetype','eq', 'water'])],
		atomic = [],
		buffs = ['b_burn'],
	},
	e_s_poison = {
		type = 'temp_s',
		screen_name = 'EF_POISON',
		name = 'poison',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_F],
		duration = 3,
		tags = ['poison', 'negative'],
		icon_text = "BUFF_DAM_NEUTRAL",
		args = [
			{obj = 'parent_args', param = 0},
			{obj = 'template', param = 'icon_text'}],
		sub_effects = [rebuild_dot('a_poison')],
		atomic = [],
		buffs = ['b_poison'],
	},
	e_s_poison_water = {
		type = 'temp_s',
		screen_name = 'EF_POISON_WATER',
		name = 'poison_water',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_F],
		duration = 3,
		tags = ['poison', 'negative'],#or may be not
		icon_text = "BUFF_DAM_WATER",
		args = [
			{obj = 'parent_args', param = 0},
			{obj = 'template', param = 'icon_text'}],
		sub_effects = [rebuild_dot('a_poison_w')],
		atomic = [],
		buffs = ['b_poison'],
	},
	e_s_poison_permanent = {
		type = 'temp_s',
		screen_name = 'EF_POISON_PERMANENT',
		name = 'poison_permanent',
		target = 'target',
		stack = 1,
		tags = ['poison', 'negative'],
		args = [{obj = 'parent_args', param = 0}],
		sub_effects = [rebuild_dot('a_poison')],
		atomic = [],
		buffs = [{
			icon = "res://assets/images/iconsskills/Debilitate.png", 
			description = "BUFF_POISON_PERMANENT",
			t_name = 'icon_poison_permanent'
		}],
	},
	e_s_bleed = {
		type = 'temp_s',
		screen_name = 'EF_BLEED',
		name = 'bleed',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_F],
		duration = 2,
		tags = ['bleed', 'negative'],
		icon_text = "BUFF_TURN_END",
		args = [
			{obj = 'parent_args', param = 0},
			{obj = 'template', param = 'icon_text'}],
		sub_effects = [rebuild_dot('a_bleed'), rebuild_remove(['tags','has','heal'])],
		atomic = [],
		buffs = ['b_bleed'],
	},
	e_s_bleed_onget = {#same as e_s_bleed, but treggered by TR_TURN_GET
		type = 'temp_s',
		screen_name = 'EF_BLEED',
		name = 'bleed_onget',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_GET],
		duration = 2,
		tags = ['bleed', 'negative'],
		icon_text = "BUFF_TURN_BEGINNING",
		args = [
			{obj = 'parent_args', param = 0},
			{obj = 'template', param = 'icon_text'}],
		sub_effects = [rebuild_dot_onget('a_bleed'), rebuild_remove(['tags','has','heal'])],
		atomic = [],
		buffs = ['b_bleed'],
	},
	e_stun = {
		type = 'temp_s',
		screen_name = 'EF_STUN',
		name = 'stun',
		target = 'target',
		stack = 1,
		duration = 'parent',
		tick_event = [variables.TR_TURN_F],
		tags = ['stun', 'negative'],
		disable = true,
		sub_effects = [rebuild_remove(['tags','has','heal'])],
		buffs = [{
			icon = "res://assets/images/iconsskills/iola_6.png", 
			description = "BUFF_STUN",
			limit = 1,
			t_name = 'icon_stun',
			bonuseffect = 'duration'
		}],
		atomic = [],
	},
	e_intimidate = {
		type = 'temp_s',
		screen_name = 'EF_INTIMIDATE',
		name = 'intimidate',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_F],
		duration = 2,
		tags = ['intimidate', 'negative'],
		sub_effects = [],
		atomic = [{type = 'stat_add_p', stat = 'damage', value = -0.5}],
		buffs = [{ 
			icon = "res://assets/images/traits/speeddebuf.png",
			description = "BUFF_INTIMIDATE",
			t_name = 'icon_intimidate',
			bonuseffect = 'duration'
		}]
	},
	e_silence = {
		type = 'temp_s',
		screen_name = 'EF_SILENCE',
		name = 'silence',
		target = 'target',
		stack = 1,
		duration = 'parent',
		tick_event = [variables.TR_TURN_F],
		tags = ['afflict', 'silence'],#does not effect skills with 'default' tag
#		disable = true,#gives no action at all, not just silence
		sub_effects = [],
		buffs = [{
			icon = "res://assets/images/iconsskills/iola_5.png", 
			description = "BUFF_SILENCE",
			t_name = 'icon_silence',
			bonuseffect = 'duration'
		}],
		atomic = [],
	},
	e_s_wound = {
		type = 'temp_s',
		screen_name = 'EF_WOUND',
		name = 'wound',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_F],
		duration = 2,
		tags = ['negative'],#or may be not
		args = [],
		atomic = [{type = 'stat_add', stat = 'resistdamage', value = -20}],
		buffs = [{
			icon = "res://assets/images/iconsskills/blood_blue.png", 
			description = "BUFF_WOUND",
			limit = 1,
			t_name = 'icon_wound',
			bonuseffect = 'duration'
		}],
	},
	e_tr_wound = rebuild_template({chance = 0.33, effect = 'e_s_wound', debug_name = "starter_wound"}),
	#effects for new skils
	e_fen_addrep = {
		type = 'trigger',
		debug_name = 'starter_add_repeat_1',
		trigger = [variables.TR_KILL],
		reset = [variables.TR_CAST],
		req_skill = true,
		conditions = [],
		atomic = [],
		buffs = [],
		sub_effects = [
			{
				type = 'oneshot',
				target = 'skill',
				atomic = [{type = 'stat_add', stat = 'repeat', value = 1}],
				buffs = [],
				sub_effects = []
			}
		]
	},
	e_fen_addrep2 = {
		type = 'trigger',
		debug_name = 'starter_add_repeat_2',
		trigger = [variables.TR_KILL],
		reset = [variables.TR_CAST],
		req_skill = true,
		conditions = [],
		atomic = [],
		buffs = [],
		sub_effects = [
			{
				type = 'oneshot',
				target = 'skill',
				atomic = [{type = 'stat_add', stat = 'repeat', value = 2}],
				buffs = [],
				sub_effects = []
			}
		]
	},
	e_fen_debuf = {
		type = 'trigger',
		debug_name = 'starter_fencing_debuf_1',
		req_skill = true,
		trigger = [variables.TR_POSTDAMAGE],
		conditions = [],
		val = 0.85,
		buff_text = '15',
		args = [
			{obj = 'template', param = 'val'},
			{obj = 'template', param = 'buff_text'}],
		sub_effects = ['e_t_nodamagearg'],
		atomic = [],
		buffs = [],
	},
	e_fen_debuf2 = {
		type = 'trigger',
		debug_name = 'starter_fencing_debuf_2',
		req_skill = true,
		trigger = [variables.TR_POSTDAMAGE],
		conditions = [],
		val = 0.75,
		buff_text = '25',
		args = [
			{obj = 'template', param = 'val'},
			{obj = 'template', param = 'buff_text'}],
		sub_effects = ['e_t_nodamagearg'],
		atomic = [],
		buffs = [],
	},
	e_t_nodamagearg = {
		type = 'temp_s',
		screen_name = 'EF_FENCING_DEBUF',
		name = 'fencing_debuf',
		target = 'target',
		tags = ['negative'],# or not? mb affliction?
		tick_event = variables.TR_TURN_S,
		duration = 2,
		stack = 1,
		sub_effects = [],
		args = [
			{obj = 'parent_args', param = 0},
			{obj = 'parent_args', param = 1}],
		atomic = [{type = 'stat_mul', stat = 'damage', value = ['parent_args', 0]}],
		buffs = [{
				icon = "res://assets/images/iconsskills/arron_7.png", 
				description = "BUFF_FENCING_DEBUFF",
				args = [{obj = 'parent_args', param = 1}],
				t_name = 'icon_fencing_debuf',
				bonuseffect = 'duration'
			}
		],
	},
	e_s_swift = {
		type = 'temp_s',
		screen_name = 'EF_SWIFT',
		name = 'swift',
		target = 'caster',
		stack = 1,
		tick_event = [variables.TR_TURN_S],
		duration = 'parent_arg',
		tags = ['buff'],
		args = [],
		sub_effects = [],
		atomic = [{type = 'stat_add', stat = 'evasion', value = 20}],
		buffs = [{
			icon = "res://assets/images/iconsskills/arron_1.png", 
			description = "BUFF_SWIFT",
			t_name = 'icon_swift',
			bonuseffect = 'duration'
		}],
	},
	e_s_protect = {
		type = 'trigger',
		debug_name = 'starter_parry',
		trigger = [variables.TR_POSTDAMAGE],
		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}],
		req_skill = true,
		args = [{obj = 'parent', param = 'caster'}, {obj = 'parent', param = 'tempdur'}],
		sub_effects = ['e_t_protect_c', 'e_t_protect_t'],
		buffs = []
	},
	e_t_protect_c = {
		type = 'temp_s',
		screen_name = 'EF_PARRY',
		name = 'parry_on_caster',
		target = 'caster',
		tick_event = variables.TR_TURN_S,
		duration = {obj = 'parent_args', param = 1},
		stack = 1,
		tags = ['buff'],
		sub_effects = ['e_t_protect_ctr', 'e_t_protect_ret', 'e_t_protect_buff'],
		atomic = [],
		buffs = [{
				icon = "res://assets/images/iconsskills/arron_2.png", 
				description = "BUFF_PARRY_RECEIVER",
				limit = 1,
				t_name = 'icon_parry_receiver',
				bonuseffect = 'duration'
			}
		],
	},
	e_t_protect_ctr = {
		type = 'trigger',
		debug_name = 'protect_cleaner',
		conditions = [],
		trigger = [variables.TR_DEATH, variables.TR_RESERVE],
		req_skill = false,
		sub_effects = [
			{
				type = 'oneshot',
				target = 'parent',
				execute = 'remove_siblings'
			},
		],
		buffs = []
	},
	e_t_protect_t = {
		type = 'temp_s',
		screen_name = 'EF_PARRY',
		name = 'parry_listener',
		target = 'target',
		tick_event = variables.TR_TURN_S,
		duration = {obj = 'parent_args', param = 1}, 
		stack = 1,
		tags = ['buff'],
		args = [{obj = 'parent_args', param = 0}],
		sub_effects = ['e_t_protect_ttr'],
		atomic = [],
		buffs = [
			{
				icon = "res://assets/images/iconsskills/arron_2.png", 
				description = "BUFF_PARRY_LISTENER",
				limit = 1,
				t_name = 'icon_parry_listener',
				bonuseffect = 'duration'
			}
		],
	},
	e_t_protect_ttr = {
		type = 'trigger',
		debug_name = 'protect_transmiter',
		conditions = [
			{type = 'skill', value = ['tags', 'has', 'damage']},
			{type = 'skill', value = ['tags', 'has_no', 'aoe']},
			{type = 'skill', value = ['tags', 'has_no', 'ignore_taunt']}
		],
		trigger = [variables.TR_DEF],
		req_skill = true,
		args = [{obj = 'parent_args', param = 0}],
		sub_effects = [
			{
				type = 'oneshot',
				target = 'owner',
				atomic = [{type = 'sfx', value = 'sfx_parry'}],
			},
			{
				type = 'oneshot',
				target = 'skill',
				args = [{obj = 'parent_args', param = 0}],
				atomic = [{type = 'stat_set', stat = 'target', value = ['parent_args', 0]}],
			},
		],
		buffs = []
	},
	e_t_protect_buff = {
		type = 'trigger',
		debug_name = 'parry_dodge',
		conditions = [
			{type = 'skill', value = ['tags', 'has', 'damage']}, 
			{type = 'skill', value = ['tags', 'has_no', 'aoe']}, 
			{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]},
			{type = 'random', value = 0.5}
		],
		trigger = [variables.TR_DEF],
		req_skill = true,
		args = [],
		sub_effects = [
			{
				type = 'oneshot',
				target = 'skill',
				args = [],
				atomic = [{type = 'stat_set', stat = 'hit_res', value = variables.RES_MISS}],
			},
		],
		buffs = []
	},
	e_t_protect_ret = {
		type = 'trigger',
		debug_name = 'parry_counterblow',
		conditions = [
			{type = 'skill', value = ['tags', 'has', 'damage']},
			{type = 'skill', value = ['tags', 'has_no', 'aoe']}
		],
		trigger = [variables.TR_POST_TARG],
		req_skill = true,
		args = [{obj = 'app_obj', param = 'damage'}],
		sub_effects = [
			{
				type = 'oneshot',
				target = 'caster',
				args = [{obj = 'parent_args', param = 0}],
				atomic = [
					{type = 'damage', source = 'slash', value = ['parent_args', 0]},
					{type = 'sfx', value = 'anim_hit'}],
			},
			{
				type = 'oneshot',
				target = 'owner',
				atomic = [
					{type = 'sfx', value = 'anim_attack'},
					{type = 'add_ultimeter',
						value = variables.ULTIMETER_COSTS[variables.TR_SKILL_FINISH]}],
			},
		],
		buffs = []
	},
	e_s_swordmas = {
		type = 'trigger',
		debug_name = 'starter_sword_mastery',
		trigger = [variables.TR_POSTDAMAGE],
		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}],
		req_skill = true,
		args = [{obj = 'parent', param = 'tempdur'}],
		sub_effects = ['e_s_swordmas_main', 'e_s_swordmas_timer'],
		buffs = []
	},
	e_s_swordmas_timer = {
		type = 'temp_p',
		screen_name = 'EF_SWORD_MASTERY',
		name = 'timer_sword_mastery',
		duration = 4,
		target = 'caster',
		tick_event = variables.TR_TURN_F,
		next_level = 'e_s_swordmas_remove',
		stack = 1,
		buffs = [{
			icon = "res://assets/images/iconsskills/arron_4.png", 
			description = "BUFF_SWORD_MASTERY",
			limit = 1,
			t_name = 'icon_sword_mastery',
			bonuseffect = 'duration'
		}],
		atomic = [],
		sub_effects = [],
		tags = ['timer', 'swordmas']
	},
	e_s_swordmas_remove = {
		type = 'oneshot',
		atomic = [{type = 'remove_all_effects', value = 'swordmas'}]
	},
	e_s_swordmas_main = {
		type = 'temp_p',
		name = 'sword_mastery',
		target = 'caster',
		duration = {obj = 'parent_args', param = 0},
		next_level = 'e_s_swordmas_remove',
		sub_effects = ['e_tr_swordmas'],
		tags = ['buff', 'swordmas'],
		stack = 1,
		atomic = [{type = 'stat_mul', stat = 'damage', value = 2.5}],
		buffs = [],
	},
	e_tr_swordmas = {
		type = 'trigger',
		debug_name = 'sword_mastery_user',
		conditions = [{type = 'skill', value = ['tags', 'has', 'damage']}],
		trigger = [variables.TR_HIT],
		req_skill = true,
		args = [],
		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'skill',
#				args = [],
#				atomic = [{type = 'stat_mul', stat = 'value', value = 2.5}],
#			},
			{
				type = 'oneshot',
				target = 'parent',
				execute = 'tick'
			},
		],
		buffs = []
	},
	e_s_termination = {
		type = 'trigger',
		debug_name = 'starter_termination_buff_1',
		trigger = [variables.TR_CAST],
		conditions = [],
		req_skill = true,
		val = 1.25,
		buff_text = '25',
		args = [
			{obj = 'template', param = 'val'},
			{obj = 'template', param = 'buff_text'}],
		sub_effects = ['e_t_termination'],
		buffs = []
	},
	e_s_termination1 = {
		type = 'trigger',
		debug_name = 'starter_termination_buff_2',
		trigger = [variables.TR_CAST],
		conditions = [],
		req_skill = true,
		val = 1.5,
		buff_text = '50',
		args = [
			{obj = 'template', param = 'val'},
			{obj = 'template', param = 'buff_text'}],
		sub_effects = ['e_t_termination'],
		buffs = []
	},
	e_t_termination = {
		type = 'temp_s',
		screen_name = 'EF_TERMINATION_BUFF',
		name = 'termination_buff',
		target = 'caster',
		duration = 3,
		tick_event = variables.TR_TURN_F,
		sub_effects = [],
		args = [
			{obj = 'parent_args', param = 0},
			{obj = 'parent_args', param = 1}],
		tags = ['buff'],
		stack = 1,
		atomic = [{type = 'stat_mul', stat = 'damage', value = ['parent_args', 0]}],
		buffs = [{
				icon = "res://assets/images/iconsskills/arron_5.png", 
				description = "BUFF_TERMINATION",
				args = [{obj = 'parent_args', param = 1}],
				limit = 1,
				t_name = 'icon_termination_buff',
				bonuseffect = 'duration'
			}
		],
	},
	e_s_smoke = {
		type = 'temp_s',
		screen_name = 'EF_SMOKE',
		name = 'smoke',
		target = 'target',
		tags = ['buff'],
		tick_event = variables.TR_TURN_S,
		duration = 1,
		stack = 1,
		sub_effects = [],
		atomic = [{type = 'stat_add', stat = 'evasion', value = 90}],
		buffs = [{
				icon = "res://assets/images/iconsskills/arron_6.png", 
				description = "BUFF_SMOKE",
				args = [],
				t_name = 'icon_smoke'
			}
		],
	},
	e_s_smoke_patch = {
		type = 'temp_s',
		screen_name = 'EF_SMOKE_RESIST',
		name = 'smoke_resist',
		target = 'target',
		tick_event = variables.TR_TURN_S,
		duration = 2,
		stack = 1,
		tags = ['buff'],
		sub_effects = [],
		atomic = [{type = 'stat_add', stat = 'resistdamage', value = 50}],
		buffs = [{
				icon = "res://assets/images/iconsskills/arron_6.png", 
				description = "BUFF_SMOKE_RESIST",
				t_name = 'icon_smoke_resist',
				bonuseffect = 'duration'
			}
		],
	},
	e_s_swipe = {
		type = 'trigger',
		debug_name = 'swipe',
		trigger = [variables.TR_POSTDAMAGE],
		conditions = [],
		req_skill = true,
		args = [],
		sub_effects = [{
			type = 'oneshot',
			target = 'target',
			atomic = [{type = 'remove_effect', value = 'buff'}]
		}],
		buffs = []
	},
	e_s_dispel = {
		type = 'trigger',
		debug_name = 'dispel',
		trigger = [variables.TR_POSTDAMAGE],
		conditions = [],
		req_skill = true,
		args = [],
		sub_effects = [{
			type = 'oneshot',
			target = 'target',
			atomic = [{type = 'remove_all_effects', value = 'negative'}]
		}],
		buffs = []
	},
	e_s_flash = {
		type = 'temp_s',
		screen_name = 'EF_FLASH',
		name = 'flash',
		target = 'target',
		tags = ['negative'],
		tick_event = variables.TR_TURN_F,
		duration = 1,
		stack = 1,
		sub_effects = [],
		atomic = [{type = 'stat_add', stat = 'hitrate', value = -25}],
		buffs = [{
				icon = "res://assets/images/iconsskills/rose_2.png", 
				description = "BUFF_FLASH",
				t_name = 'icon_flash'
			}
		],
	},
	e_t_deluge = {
		type = 'trigger',
		debug_name = 'deluge',
		target = 'target',
		trigger = [variables.TR_DEF],
		conditions = [
			{type = 'skill', value = ['damagetype','eq', 'air'] },
			{type = 'skill', value = ['hit_res','mask',variables.RES_HITCRIT] }
		],
		req_skill = true,
		sub_effects = [
			{
				type = 'oneshot',
				target = 'skill',
				atomic = [{type = 'stat_mul', stat = 'value', value = 1.3}],
				sub_effects = []
			},
			{
				type = 'oneshot',
				target = 'self',
				execute = 'remove'
			}
		],
		buffs = [{
			icon = "res://assets/images/iconsskills/rose_5.png", 
			description = "BUFF_DELUGE",
			limit = 1,
			t_name = 'icon_deluge'
		}]
	},
	e_s_renew = {
		type = 'temp_s',
		screen_name = 'EF_RENEW',
		name = 'renew_timer',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_S],
		duration = 2,
		tags = ['buff'],
		args = [{obj = 'parent_args', param = 0}],
		sub_effects = ['e_renew'],
		atomic = [],
		buffs = [{
			icon = "res://assets/images/iconsskills/rose_8.png", 
			description = "BUFF_RENEW",
			args = [{obj = 'parent_args', param = 0}],
			t_name = 'icon_renew',
			bonuseffect = 'duration'
		}],
	},
	e_renew = {
		type = 'trigger',
		debug_name = 'renew',
		trigger = [variables.TR_TURN_S],
		req_skill = false,
		conditions = [],
		args = [{obj = 'parent_args', param = 0}],
		sub_effects = [{
				type = 'oneshot',
				target = 'owner',
				args = [{obj = 'parent_args', param = 0}],
				atomic = [{type = 'heal', value = ['parent_args', 0]}],
			}
		],
		buffs = []
	},
	e_s_renew1 = {
		type = 'temp_s',
		screen_name = 'EF_RENEW_RESIST',
		name = 'renew_resist_1',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_S],
		duration = 2,
		val = 20,
		tags = ['buff'],
		args = [{obj = 'template', param = 'val'}],
		sub_effects = [],
		atomic = ['a_renew_resist'],
		buffs = ['b_renew1'],
	},
	e_s_renew2 = {
		type = 'temp_s',
		screen_name = 'EF_RENEW_RESIST',
		name = 'renew_resist_2',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_S],
		duration = 2,
		val = 30,
		tags = ['buff'],
		args = [{obj = 'template', param = 'val'}],
		sub_effects = [],
		atomic = ['a_renew_resist'],
		buffs = ['b_renew1'],
	},
	e_s_explosion = {
		type = 'trigger',
		debug_name = 'explosion_ultra',
		trigger = [variables.TR_HIT],
		conditions = [{type = 'combat', value = {type = 'single_enemy'}}],
		req_skill = true,
		args = [],
		sub_effects = [{
			type = 'oneshot',
			target = 'skill',
			atomic = [{type = 'stat_mul', stat = 'value', value = 3}],
			sub_effects = []
		}],
		buffs = []
	},
	e_t_aarrow = {
		type = 'trigger',
		debug_name = 'air_arrow_mul',
		target = 'target',
		trigger = [variables.TR_DEF],
		conditions = [
			{type = 'skill', value = ['damagetype','eq', 'air'] },
			{type = 'skill', value = ['hit_res','mask',variables.RES_HITCRIT] }
		],
		req_skill = true,
		sub_effects = [
			{
				type = 'oneshot',
				target = 'skill',
				atomic = [{type = 'stat_mul', stat = 'value', value = 1.5}],
				sub_effects = []
			},
			{
				type = 'oneshot',
				target = 'self',
				execute = 'remove'
			}
		],
		buffs = [{
			icon = "res://assets/images/iconsskills/erika_2.png", 
			description = "BUFF_AIR_ARROW",
			limit = 1,
			t_name = 'icon_air_arrow'
		}]
	},
	e_s_aarrow1 = {
		type = 'temp_s',
		name = 'air_arrow_ignor_1',
		target = 'target',
		stack = 1,
		rem_event = variables.TR_POST_TARG,
		tags = ['negative'],
		args = [],
		sub_effects = [],
		atomic = [{type = 'stat_mul', stat = 'resistair', value = 0.65}],
		buffs = [],
	},
	e_s_aarrow2 = {
		type = 'temp_s',
		name = 'air_arrow_ignor_2',
		target = 'target',
		stack = 1,
		rem_event = variables.TR_POST_TARG,
		tags = ['negative'],
		args = [],
		sub_effects = [],
		atomic = [{type = 'stat_mul', stat = 'resistair', value = 0.3}],
		buffs = [],
	},
	e_t_eastrike = {
		type = 'trigger',
		debug_name = 'earth_strike_stun_mul',
		req_skill = true,
		trigger = [variables.TR_HIT],
		conditions = [{type = 'target', value = {type = 'status', status = 'stun', check = true}}],
		sub_effects = [
			{
				type = 'oneshot',
				target = 'skill',
				atomic = [{type = 'stat_mul', stat = 'value', value = 1.3}],
				buffs = [],
				sub_effects = []
			}
		]
	},
	e_s_freeze = {
		type = 'temp_s',
		screen_name = 'EF_FREEZE',
		name = 'freeze',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_F],
		duration = 2,
		disable = true,
		tags = ['negative', 'stun'],
		args = [],
		sub_effects = ['e_t_freeze'],
		atomic = [],
		buffs = [{
			icon = "res://assets/images/iconsskills/erika_5.png",
			description = "BUFF_FREEZE",
			limit = 1,
			t_name = 'icon_freeze',
			bonuseffect = 'duration'
		}],
	},
	e_t_freeze = {
		type = 'trigger',
		debug_name = 'freeze_damage_doubler',
		trigger = [variables.TR_DEF],
		conditions = [
			{type = 'skill', value = ['hit_res','mask',variables.RES_HITCRIT] }
		],
		req_skill = true,
		sub_effects = [
			{
				type = 'oneshot',
				target = 'skill',
				atomic = [{type = 'stat_mul', stat = 'value', value = 2}],
				sub_effects = []
			},
			{
				type = 'oneshot',
				target = 'parent',
				execute = 'remove'
			}
		],
		buffs = []
	},
	e_s_chill = {
		type = 'temp_s',
		screen_name = 'EF_CHILL',
		name = 'chill',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_GET],
		duration = 3,
		tags = ['negative', 'chill'],
		args = [{obj = 'parent_args', param = 0}],
		sub_effects = ['e_chill'],
		atomic = [],
		buffs = [{
			icon = "res://assets/images/iconsskills/erika_5.png", 
			description = "BUFF_CHILL",
			t_name = 'icon_chill',
			bonuseffect = 'duration'
		}],
	},
	e_chill = {
		type = 'trigger',
		debug_name = "chill_damager",
		trigger = [variables.TR_TURN_GET],
		req_skill = false,
		conditions = [],
		args = [{obj = 'parent_args', param = 0}],
		sub_effects = [{
				type = 'oneshot',
				target = 'owner',
				args = [{obj = 'parent_args', param = 0}],
				atomic = [{type = 'damage', source = 'water', value = [['parent_args', 0], '/', 2.25]}],#skill gives 0.9 of base damage 0.9/2.25 = 0.4
			}
		],
		buffs = []
	},
	e_s_arrshower = {
		type = 'temp_s',
		screen_name = 'EF_ARROW_SHOWER_DEBUFF',
		name = 'arrow_shower_debuff',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_F],
		duration = 1,
		tags = ['negative'],
		args = [],
		sub_effects = [],
		atomic = [{type = 'stat_add', stat = 'hitrate', value = -15}],
		buffs = [{
			icon = "res://assets/images/iconsskills/erika_3.png", 
			description = "BUFF_ARROW_SHOWER_DEBUFF",
			t_name = 'icon_arrow_shower_debuff'
		}],
	},
	#Here is TR_TURN_F-type implementation for e_t_nat_bless. Idea is to secure an ability for each
	#char to use bless for exactly 2 turns, witch is not guaranteed with TR_TURN_S-type
#	e_t_nat_bless_caster = {
#		type = 'trigger',
#		debug_name = 'starter_nature_bless_caster',
#		trigger = [variables.TR_POSTDAMAGE],
#		req_skill = true,
#		conditions = [{type = 'target', value = {type = 'stats', stat = 'id', value = 'erika', operant = 'eq'}}],
#		val = 3,
#		args = [{obj = 'template', param = 'val'}],
#		buffs = [],
#		sub_effects = ['e_s_nat_bless']
#	},
#	e_t_nat_bless_others = {
#		type = 'trigger',
#		debug_name = 'starter_nature_bless_others',
#		trigger = [variables.TR_POSTDAMAGE],
#		req_skill = true,
#		conditions = [{type = 'target', value = {type = 'stats', stat = 'id', value = 'erika', operant = 'neq'}}],
#		val = 2,
#		args = [{obj = 'template', param = 'val'}],
#		buffs = [],
#		sub_effects = ['e_s_nat_bless']
#	},
	#TR_TURN_S-type implementation
	e_t_nat_bless_common = {
		type = 'trigger',
		debug_name = 'starter_nature_bless',
		trigger = [variables.TR_POSTDAMAGE],
		conditions = [],
		req_skill = true,
		sub_effects = ['e_s_nat_bless']
	},
	e_s_nat_bless = {
		type = 'temp_s',
		screen_name = 'EF_NATURE_BLESS',
		name = 'nature_bless',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_S],
		duration = 2,#{obj = 'parent_args', param = 0},#for TR_TURN_F-type implementation
		tags = ['buff'],
		args = [],
		sub_effects = [],
		atomic = [
			{type = 'stat_mul', stat = 'hpmax', value = 1.20},
#			{type = 'stat_add', stat = 'hitrate', value = 20},#old bonus, delate with time
			{type = 'stat_add_p', stat = 'damage', value = 0.20},
			],
		buffs = [{ 
			icon = "res://assets/images/iconsskills/erika_1.png", 
			description = "BUFF_NATURE_BLESS",
			t_name = 'icon_nature_bless',
			bonuseffect = 'duration'
		}],
	},
	e_s_hearts = {
		type = 'temp_s',
		screen_name = 'EF_HEARTSEEKER_DEBUFF',
		name = 'heartseeker_debuff',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_F],
		duration = 4,
		tags = ['negative'],
		args = [],
		sub_effects = [],
		atomic = [{type = 'stat_add', stat = 'resistdamage', value = -25}],
		buffs = [{ 
			icon = "res://assets/images/iconsskills/erika_7.png", 
			description = "BUFF_HEARTSEEKER_DEBUFF",
			t_name = 'icon_heartseeker_debuff',
			bonuseffect = 'duration'
		}],
	},
	e_s_charm = {
		type = 'temp_s',
		screen_name = 'EF_CHARM',
		name = 'charm',
		target = 'target',
		duration = 3,
		tick_event = [variables.TR_TURN_F],
		sub_effects = [],
		tags = ['negative'],
		stack = 1,
		atomic = [{type = 'stat_mul', stat = 'damage', value = 0.5}],
		buffs = [{
				icon = "res://assets/images/iconsskills/erika_8.png", 
				description = "BUFF_CHARM",
				limit = 1,
				t_name = 'icon_charm',
				bonuseffect = 'duration'
			}
		],
	},
	e_s_charm1 = {
		type = 'trigger',
		debug_name = "charm_away",
		trigger = [variables.TR_POSTDAMAGE],
		conditions = [
			{type = 'skill', value = ['hit_res','mask',variables.RES_HITCRIT] },
			{type = 'target', value = [{type = 'is_boss', check = false}]}
		],
		req_skill = true,
		args = [],
		sub_effects = [{
			type = 'static',
			tags = ['charmed'],
			target = 'target',
			atomic = []
		}],
		buffs = []
	},
	e_t_combo1 = {
		type = 'trigger',
		debug_name = "combo_stun_mul_1",
		trigger = [variables.TR_HIT],
		conditions = [
			{type = 'target', value = {type = 'status', status = 'stun', check = true}}
		],
		req_skill = true,
		sub_effects = [
			{
				type = 'oneshot',
				target = 'skill',
				atomic = [{type = 'stat_mul', stat = 'value', value = 1.25}],
				sub_effects = []
			},
		],
		buffs = []
	},
	e_t_combo2 = {
		type = 'trigger',
		debug_name = "combo_stun_mul_2",
		trigger = [variables.TR_HIT],
		conditions = [
			{type = 'target', value = {type = 'status', status = 'stun', check = true}}
		],
		req_skill = true,
		sub_effects = [
			{
				type = 'oneshot',
				target = 'skill',
				atomic = [{type = 'stat_mul', stat = 'value', value = 1.5}],
				sub_effects = []
			},
		],
		buffs = []
	},
	e_s_firepunch = {
		type = 'temp_s',
		screen_name = 'EF_FIREPUNCH_DEBUFF',
		name = 'timer_firepunch_debuff',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_F],
		duration = 2,
		tags = ['negative'],
		args = [],
		sub_effects = ['e_t_firepunch'],#maybe it would be better to make it through resistdamage
		atomic = [],
		buffs = [{
			icon = "res://assets/images/iconsskills/ember_4.png",
			description = "BUFF_FIREPUNCH_DEBUFF",
			limit = 1,
			t_name = 'icon_firepunch_debuff',
			bonuseffect = 'duration'
		}],
	},
	e_t_firepunch = {
		type = 'trigger',
		debug_name = "vulnerability_debuff",
		trigger = [variables.TR_DEF],
		conditions = [
			{type = 'skill', value = ['hit_res','mask',variables.RES_HITCRIT] }
		],
		req_skill = true,
		sub_effects = [
			{
				type = 'oneshot',
				target = 'skill',
				atomic = [{type = 'stat_mul', stat = 'value', value = 1.2}],
				sub_effects = []
			},
		],
		buffs = []
	},
	e_t_punch1 = {
		type = 'trigger',
		debug_name = "firepunch_burn_mul",
		trigger = [variables.TR_HIT],
		conditions = [
			{type = 'target', value = {type = 'status', status = 'burn', check = true}}
		],
		req_skill = true,
		sub_effects = [
			{
				type = 'oneshot',
				target = 'skill',
				atomic = [{type = 'stat_mul', stat = 'value', value = 1.3}],
				sub_effects = []
			},
		],
		buffs = []
	},
	e_t_punch2 = {
		type = 'trigger',
		debug_name = "firepunch_burn",
		trigger = [variables.TR_POSTDAMAGE],
		conditions = [
			{type = 'target', value = {type = 'status', status = 'burn', check = false}},
			{type = 'skill', value = ['hit_res','mask',variables.RES_HITCRIT] },
		],
		args = [{obj = 'parent', param = 'process_value'}],
		req_skill = true,
		sub_effects = ['e_s_burn_onget'],
		buffs = []
	},

	e_s_shockwave = {
		type = 'temp_s',
		screen_name = 'EF_SHOCKWAVE_DEBUFF',
		name = 'shockwave_debuff',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_F],
		duration = 1,
		tags = ['negative'],
		args = [],
		sub_effects = [],
		atomic = [{type = 'stat_add', stat = 'hitrate', value = -20}],
		buffs = [{
				icon = "res://assets/images/iconsskills/ember_3.png", 
				description = "BUFF_SHOCKWAVE_DEBUFF",
				args = [],
				t_name = 'icon_shockwave_debuff'
			}],
	},
	e_s_uppercut = {
		type = 'temp_s',
		screen_name = 'EF_UPPERCUT',
		name = 'timer_uppercut',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_GET],
		duration = 1,
		tags = ['negative', 'uppercut'],
		args = [],
		sub_effects = ['e_t_uppercut'],
		atomic = [],
		buffs = [{
			icon = "res://assets/images/iconsskills/ember_1.png", 
			description = "BUFF_UPPERCUT",
			limit = 1,
			t_name = 'icon_uppercut',
			bonuseffect = 'duration'
		}],
	},
	e_t_uppercut = {
		type = 'trigger',
		debug_name = "uppercut_mul",
		target = 'target',
		trigger = [variables.TR_DEF],
		conditions = [
			{type = 'skill', value = ['damagetype', 'eq', 'air'] },
			{type = 'skill', value = ['hit_res','mask',variables.RES_HITCRIT] }
		],
		req_skill = true,
		sub_effects = [
			{
				type = 'oneshot',
				target = 'skill',
				atomic = [{type = 'stat_mul', stat = 'value', value = 1.5}],
				sub_effects = []
			},
			{
				type = 'oneshot',
				target = 'parent',
				execute = 'remove'
			}
		],
		buffs = []
	},
	e_s_protect_er = {
		type = 'trigger',
		debug_name = 'starter_defend',
		trigger = [variables.TR_POSTDAMAGE],
		conditions = [
			{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]},
			{type = 'target', value = {type = 'stats', stat = 'id', value = 'ember', operant = 'neq'}}
		],
		req_skill = true,
		args = [{obj = 'parent', param = 'caster'}],
		sub_effects = ['e_t_protect_c_er', 'e_t_protect_t_er'],
		buffs = []
	},
	e_t_protect_c_er = {
		type = 'temp_s',
		name = 'defend_on_caster',
		target = 'caster',
		tick_event = variables.TR_TURN_S,
		duration = 1, 
		stack = 0,
		tags = [],
		sub_effects = ['e_t_protect_ctr'],
		atomic = [],
		buffs = [],
	},
	e_t_protect_t_er = {
		type = 'temp_s',
		screen_name = 'EF_DEFEND',
		name = 'defend_listener',
		target = 'target',
		tick_event = variables.TR_TURN_S,
		duration = 1, 
		stack = 1,
		tags = ['buff'],
		args = [{obj = 'parent_args', param = 0}],
		sub_effects = ['e_t_protect_ttr'],
		atomic = [],
		buffs = [{
				icon = "res://assets/images/iconsskills/ember_6.png", 
				description = "BUFF_DEFEND_LISTENER",
				limit = 1,
				t_name = 'icon_defend_listener'
			}
		],
	},
	e_s_defend = {
		type = 'temp_s',
		screen_name = 'EF_DEFEND_BUFF',
		name = 'defend_buff',
		target = 'caster',
		stack = 1,
		tick_event = [variables.TR_TURN_S],
		duration = 1,
		tags = ['buff'],
		args = [],
		sub_effects = [],
		atomic = [{type = 'stat_add', stat = 'resistdamage', value = 25}],
		buffs = [{
			icon = "res://assets/images/iconsskills/ember_6.png", 
			description = "BUFF_DEFEND_BUFF",
			t_name = 'icon_defend_buff',
		}],
	},
	e_t_dragonprot = {
		type = 'temp_s',
		screen_name = 'EF_DRAGON_PROTECTION',
		name = 'dragon_protection',
		target = 'target',
		tick_event = variables.TR_TURN_S,
		duration = 1,
		stack = 1,
		tags = ['bless'],
		args = [
			{obj = 'parent_args', param = 0},
			{obj = 'app_obj', param = 'shield', dynamic = true}],
		sub_effects = [],
		atomic = [
			{type = 'shield_add_temporal', shield_id = 'dragonprot', value = ['parent_args', 0]},
			{type = 'stat_add', stat = 'resistnegative', value = 100}
		],
		buffs = [{
			icon = "res://assets/images/iconsskills/ember_2.png", 
			description = "BUFF_DRAGON_PROTECTION",
			args = [{obj = 'parent_args', param = 1}],
			limit = 1,
			t_name = 'icon_dragon_protection'
		}],
	},
	#delete with time
#	e_t_dragonprot1 = {
#		type = 'temp_s',
#		name = 'dragon_protection2',
#		target = 'target',
#		tick_event = variables.TR_TURN_F,
#		rem_event = variables.TR_COMBAT_F,
#		duration = 1,
#		stack = 1,
#		tags = ['bless'],
#		args = [
#			{obj = 'parent_args', param = 0},
#			{obj = 'app_obj', param = 'shield', dynamic = true}],
#		sub_effects = [],
#		atomic = [
#			{type = 'shield_add_temporal', shield_id = 'dragonprot1', value = [['parent_args', 0], '*', 2]},
#			{type = 'stat_set_revert', stat = 'resistnegative', value = 100}
#		],
#		buffs = ['b_dragonprot'],
#	},
	e_s_aegis = {
		type = 'temp_s',
		screen_name = 'EF_AEGIS',
		name = 'aegis',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_S],
		duration = 1,
		tags = ['buff'],
		args = [],
		sub_effects = [],
		atomic = [{type = 'stat_add', stat = 'resistdamage', value = 75}],
		buffs = [{
			icon = "res://assets/images/iconsskills/ember_8.png", 
			description = "BUFF_AEGIS",
			t_name = 'icon_aegis',
			bonuseffect = 'duration'
		}],
	},
	e_s_aegis1 = {
		type = 'temp_s',
		screen_name = 'EF_AEGIS_HP',
		name = 'aegis_hp',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_S],
		duration = 3,
		tags = ['buff'],
		args = [],
		sub_effects = [],
		atomic = [{type = 'stat_mul', stat = 'hpmax', value = 1.25}],
		buffs = [{
			icon = "res://assets/images/iconsskills/ember_8.png",
			description = "BUFF_AEGIS_HP",
			t_name = 'icon_aegis_hp',
			bonuseffect = 'duration'
		}],
	},
	e_t_orb = {
		type = 'temp_s',
		screen_name = 'EF_ORB',
		name = 'orb',
		target = 'target',
		tags = ['negative'],
		tick_event = variables.TR_TURN_S,
		duration = 2,
		stack = 1,
		sub_effects = [],
		atomic = [
			{type = 'stat_add', stat = 'resistlight', value = -25},
			{type = 'stat_add', stat = 'resistdark', value = -25},
		],
		buffs = [{
				icon = "res://assets/images/iconsskills/rilu_6.png", 
				description = "BUFF_ORB",
				limit = 1,
				t_name = 'icon_orb',
				bonuseffect = 'duration'
			}
		],
	},
	e_orb_addrep1 = {
		type = 'trigger',
		debug_name = 'orb_repeater_1',
		trigger = [variables.TR_CAST],
		req_skill = true,
		conditions = [{type = 'random', value = 0.25}],
		atomic = [],
		buffs = [],
		sub_effects = ['e_orb_rep']
	},
	e_orb_addrep2 = {
		type = 'trigger',
		debug_name = 'orb_repeater_2',
		trigger = [variables.TR_CAST],
		req_skill = true,
		conditions = [{type = 'random', value = 0.45}],
		atomic = [],
		buffs = [],
		sub_effects = ['e_orb_rep']
	},
	e_orb_rep = {
		type = 'oneshot',
		target = 'skill',
		atomic = [{type = 'stat_add', stat = 'repeat', value = 1}],
		buffs = [],
		sub_effects = []
	},
	e_s_mist = {
		type = 'temp_s',
		screen_name = 'EF_MIST_DEBUFF',
		name = 'mist_debuff',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_GET],
		duration = 3,
		tags = ['negative'],
		args = [],
		sub_effects = [],
		atomic = [{type = 'stat_add', stat = 'hitrate', value = -25}],
		buffs = [{
				icon = "res://assets/images/iconsskills/rilu_3.png", 
				description = "BUFF_MIST_DEBUFF",
				t_name = 'icon_mist_debuff',
				bonuseffect = 'duration'
			}],
	},
	e_t_mist = {
		type = 'temp_s',
		screen_name = 'EF_MIST',
		name = 'mist_timer',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_GET],
		duration = 3,
		tags = ['negative', 'mist'],
		args = [{obj = 'parent_args', param = 0}],
		sub_effects = ['e_mist'],
		atomic = [],
		buffs = [{
			icon = "res://assets/images/iconsskills/rilu_3.png", 
			description = "BUFF_MIST",
			t_name = 'icon_mist',
			bonuseffect = 'duration'
		}],
	},
	e_mist = {
		type = 'trigger',
		debug_name = 'mist',
		trigger = [variables.TR_TURN_GET],
		req_skill = false,
		conditions = [],
		args = [{obj = 'parent_args', param = 0}],
		sub_effects = [{
				type = 'oneshot',
				target = 'owner',
				args = [{obj = 'parent_args', param = 0}],
				atomic = [{type = 'damage', source = 'water', value = [['parent_args', 0], '*', 2]}],
			}
		],
		buffs = []
	},
	e_s_ava = {
		type = 'temp_s',
		screen_name = 'EF_AVALANCHE_DEBUFF',
		name = 'avalanche_debuff',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_F],
		duration = 1,
		tags = ['negative'],
		args = [],
		sub_effects = [],
		atomic = [{type = 'stat_add', stat = 'resistdamage', value = -20}],
		buffs = [{
			icon = "res://assets/images/iconsskills/rilu_1.png", 
			description = "BUFF_AVALANCHE_DEBUFF",
			t_name = 'icon_avalanche_debuff',
			bonuseffect = 'duration'
		}],
	},
	e_t_thorns = {
		type = 'trigger',
		debug_name = 'soulthorns_mul',
		trigger = [variables.TR_HIT],
		conditions = [
			{type = 'target', value = {type = 'status', status = 'stun', check = true}}
		],
		req_skill = true,
		sub_effects = [
			{
				type = 'oneshot',
				target = 'skill',
				atomic = [{type = 'stat_mul', stat = 'value', value = 1.4}],
			},
		],
		buffs = []
	},
	e_echo_shield = {
		type = 'oneshot',
		target = 'caster',
		args = [{obj = 'parent_args', param = 0}],
		atomic = [{type = 'stat_add', stat = 'shield', value = ['parent_args', 0]}]
	},
	e_s_echo = {
		type = 'trigger',
		debug_name = 'starter_echo_taunt',
		trigger = [variables.TR_POSTDAMAGE],
		conditions = [],
		req_skill = true,
		args = [{obj = 'parent', param = 'caster'}],
		sub_effects = ['e_echo_taunt', 'e_echo_shield_icon'],
		buffs = []
	},
	e_echo_shield_icon = {
		type = 'temp_s',
		screen_name = 'EF_ECHO_SHIELD',
		name = 'echo_shield',
		target = 'caster',
		rem_event = variables.TR_SHIELD_DOWN,
		stack = 1,
		args = [{obj = 'app_obj', param = 'shield', dynamic = true}],
		buffs = [{
			icon = "res://assets/images/iconsskills/rilu_8.png", 
			description = "BUFF_ECHO_SHIELD",
			args = [{obj = 'parent_args', param = 0}],
			limit = 1,
			t_name = 'icon_echo_shield'
		}],
		sub_effects = [],
	},
	e_echo_taunt = {
		type = 'temp_s',
		screen_name = 'EF_ECHO_TAUNT',
		name = 'echo_taunt',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_S],
		duration = 2,
		tags = ['taunt'],
		args = [{obj = 'parent_arg_get', index = 0, param = 'id'}],
		sub_effects = [],
		atomic = [{type = 'stat_set_revert', stat = 'taunt', value = ['parent_args', 0]}],
		buffs = [{
			icon = "res://assets/images/iconsskills/rilu_8.png", 
			description = "BUFF_ECHO_TAUNT",
			limit = 1,
			t_name = 'icon_echo_taunt',
			bonuseffect = 'duration'
		}],
	},
	e_t_beam = {
		type = 'oneshot',
		target = 'target',
		args = [],
		atomic = [{type = 'stat_set', stat = 'shield', value = 0}]
	},
	e_s_beam_debuff = {
		type = 'temp_s',
		screen_name = 'EF_BEAM_DEBUFF',
		name = 'timer_beam_debuff',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_F],
		duration = 2,
		tags = ['negative'],
		args = [],
		sub_effects = ['e_t_firepunch'],
		atomic = [],
		buffs = [{
			icon = "res://assets/images/iconsskills/rilu_4.png",
			description = "BUFF_BEAM_DEBUFF",
			limit = 1,
			t_name = 'icon_beam_debuff',
			bonuseffect = 'duration'
		}],
	},
	e_t_soulprot = {
		type = 'temp_s',
		screen_name = 'EF_SOULPROT',
		name = 'soulprot',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_S],
		duration = 2,
		tags = ['buff', 'soulprot'],
		args = [],
		sub_effects = [],
		atomic = [],
		buffs = [{
			icon = "res://assets/images/iconsskills/rilu_5.png",
			description = "BUFF_SOULPROT",
			t_name = 'icon_soulprot',
			limit = 1,
			bonuseffect = 'duration'
		}]
	},
	e_s_gust1 = {
		type = 'temp_s',
		screen_name = 'EF_GUSTOFWIND_DEBUFF',
		name = 'gustofwind_debuff1',
		target = 'target',
		duration = 2,
		tick_event = [variables.TR_TURN_F],
		sub_effects = [],
		tags = ['negative'],
		stack = 1,
		atomic = [{type = 'stat_mul', stat = 'damage', value = 0.85}],
		buff_text = '15',
		args = [{obj = 'template', param = 'buff_text'}],
		buffs = ['b_gust'],
	},
	e_s_gust2 = {
		type = 'temp_s',
		screen_name = 'EF_GUSTOFWIND_DEBUFF',
		name = 'gustofwind_debuff2',
		target = 'target',
		duration = 2,
		tick_event = [variables.TR_TURN_F],
		sub_effects = [],
		tags = ['negative'],
		stack = 1,
		atomic = [{type = 'stat_mul', stat = 'damage', value = 0.75}],
		buff_text = '25',
		args = [{obj = 'template', param = 'buff_text'}],
		buffs = ['b_gust'],
	},
	e_s_cleanse = {
		type = 'oneshot',
		target = 'target',
		atomic = [{type = 'remove_all_effects', value = 'buff'}]
	},
	e_s_resetfire = {
		type = 'trigger',
		debug_name = 'resetfire',
		trigger = [variables.TR_POSTDAMAGE],
		conditions = [
			{type = 'target', value = {type = 'status', status = 'burn', check = true}},
			{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}
		],
		req_skill = true,
		sub_effects = ['e_s_burn_onget'],
		buffs = []
	},
	e_t_iola_barrier = {
		type = 'temp_s',
		screen_name = 'EF_IOLA_BARRIER',
		name = 'iola_barrier',
		target = 'target',
		tick_event = variables.TR_TURN_S,
		duration = 1,
		stack = 1,
		args = [
			{obj = 'parent_args', param = 0},
			{obj = 'app_obj', param = 'shield', dynamic = true}],
		sub_effects = [],
		atomic = [
			{type = 'shield_add_temporal', shield_id = 'iola_barrier', value = ['parent_args', 0]},
		],
		buffs = [{
			icon = "res://assets/images/iconsskills/iola_1.png", 
			description = "BUFF_IOLA_BARRIER",
			args = [{obj = 'parent_args', param = 1}],
			limit = 1,
			t_name = 'icon_iola_barrier'
		}],
	},
	e_t_bless_caster = {
		type = 'trigger',
		debug_name = 'starter_bless_caster',
		trigger = [variables.TR_POSTDAMAGE],
		req_skill = true,
		conditions = [{type = 'target', value = {type = 'stats', stat = 'id', value = 'iola', operant = 'eq'}}],
		val = 3,
		args = [{obj = 'template', param = 'val'}],
		buffs = [],
		sub_effects = ['e_s_bless']
	},
	e_t_bless_others = {
		type = 'trigger',
		debug_name = 'starter_bless_others',
		trigger = [variables.TR_POSTDAMAGE],
		req_skill = true,
		conditions = [{type = 'target', value = {type = 'stats', stat = 'id', value = 'iola', operant = 'neq'}}],
		val = 2,
		args = [{obj = 'template', param = 'val'}],
		buffs = [],
		sub_effects = ['e_s_bless']
	},
	e_s_bless = {
		type = 'temp_s',
		screen_name = 'EF_BLESS',
		name = 'bless',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_F],
		duration = {obj = 'parent_args', param = 0},
		tags = ['buff'],
		args = [],
		sub_effects = [],
		atomic = [
			{type = 'stat_add', stat = 'hitrate', value = 25},
			{type = 'stat_add_p', stat = 'damage', value = 0.15},
			],
		buffs = [{ 
			icon = "res://assets/images/iconsskills/iola_2.png", 
			description = "BUFF_BLESS",
			t_name = 'icon_bless',
			bonuseffect = 'duration'
		}],
	},
	e_s_sanct = {
		type = 'trigger',
		debug_name = 'sanctuary_resurrect',
		trigger = [variables.TR_POSTDAMAGE],
		conditions = [],
		req_skill = false,
		sub_effects = [{
			type = 'oneshot',
			target = 'target',
			atomic = [{type = 'resurrect', value_p = 0.2}] 
		}]
	},
	e_s_viccull = {
		type = 'temp_s',
		screen_name = 'EF_CULLING',
		name = 'culling',
		target = 'target',
		stack = 10,
#		tick_event = [variables.TR_TURN_F],#for now it's only stackable and dispelable
#		duration = 2,
		tags = ['negative'],
		args = [],
		sub_effects = [],
		atomic = [{type = 'stat_add', stat = 'resistdamage', value = -20}],
		buffs = [{
			icon = "res://assets/images/traits/armorignore.png", 
			description = "BUFF_CULLING",
			limit = 1,
			t_name = 'icon_culling',
			bonuseffect = 'amount'
		}],
	},
	e_tr_vicen = {
		type = 'trigger',
		debug_name = 'energyburst_buff_starter',
		trigger = [variables.TR_CAST],
		conditions = [],
		req_skill = true,
		sub_effects = ['e_s_vicen']
	},
	e_s_vicen = {
		type = 'temp_s',
		screen_name = 'EF_ENERGYBURST_BUFF',
		name = 'energyburst_buff',
		target = 'caster',
		tags = ['buff'],
		tick_event = variables.TR_TURN_S,
		duration = 3,
		stack = 1,
		sub_effects = [],
		atomic = [{type = 'stat_add', stat = 'evasion', value = 25}],
		buffs = [{
				icon = "res://assets/images/traits/dodge.png", 
				description = "BUFF_ENERGYBURST_BUFF",
				t_name = 'icon_energyburst_buff',
				bonuseffect = 'duration'
			}
		],
	},
	e_s_def = {#same as Ember's defend, but for enemy
		type = 'trigger',
		debug_name = 'starter_guard',
		trigger = [variables.TR_POSTDAMAGE],
		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}],
		req_skill = true,
		args = [{obj = 'parent', param = 'caster'}],
		sub_effects = ['e_t_def_c', 'e_t_def_t'],
		buffs = []
	},
	e_t_def_c = {
		type = 'temp_s',
		screen_name = 'EF_GUARD',
		name = 'guard_on_caster',
		target = 'caster',
		tick_event = variables.TR_TURN_S,
		duration = 2, 
		stack = 1,
		tags = ['buff'],
		sub_effects = ['e_t_protect_ctr', 'e_t_def_ctr1'],
		atomic = [{type = 'stat_add', stat = 'resistdamage', value = 25}],
		buffs = [{
				icon = "res://assets/images/iconsskills/ember_6.png", 
				description = "BUFF_GUARD_ON_CASTER",
				limit = 1,
				t_name = 'icon_guard_on_caster'
			}
		],
	},
	e_t_def_ctr1 = {
		type = 'trigger',
		debug_name = 'guard_on_stun_cleaner',
		conditions = [{type = 'owner', value = {type = 'status', status = 'stun', check = true} }],
		trigger = [variables.TR_POST_TARG],
		req_skill = false,
		sub_effects = [
			{
				type = 'oneshot',
				target = 'parent',
				execute = 'remove_siblings'
			},
		],
		buffs = []
	},
	e_t_def_t = {
		type = 'temp_s',
		screen_name = 'EF_GUARD',
		name = 'guard_listener',
		target = 'target',
		tick_event = variables.TR_TURN_S,
		duration = 2, 
		stack = 1,
		tags = ['buff'],
		args = [{obj = 'parent_args', param = 0}],
		sub_effects = ['e_t_protect_ttr'],
		atomic = [],
		buffs = [{
				icon = "res://assets/images/iconsskills/ember_6.png", 
				description = "BUFF_GUARD_LISTENER",
				limit = 1,
				t_name = 'icon_guard_listener'
			}
		],
	},
	
	e_i_resurrect20 = {
		type = 'oneshot',
		target = 'target',
		atomic = [{type = 'resurrect', value_p = 0.2}] 
	},
	e_i_resurrect100 = {
		type = 'oneshot',
		target = 'target',
		atomic = [{type = 'resurrect', value_p = 1.0}] 
	},
	e_i_atkup = {
		type = 'temp_s',
		screen_name = 'EF_SCROLL_OFFENSE',
		name = 'scroll_offense',
		target = 'target',
		stack = 1,
		tick_event = [variables.TR_TURN_F],
		duration = 3,
		tags = ['buff'],
		args = [],
		sub_effects = [],
		atomic = [{type = 'stat_add_p', stat = 'damage', value = 0.5}],
		buffs = [{
				icon = "res://assets/images/iconsskills/defaultattack.png", 
				description = "BUFF_SCROLL_OFFENSE",
				limit = 1,
				t_name = 'icon_scroll_offense',
				bonuseffect = 'duration'
			}
		],
	},
	e_i_defup = {
		type = 'temp_s',
		screen_name = 'EF_SCROLL_DEFENCE',
		name = 'scroll_defence',
		target = 'target',
		tick_event = variables.TR_TURN_F,
		duration = 3, 
		stack = 1,
		tags = ['buff'],
		sub_effects = [],
		atomic = [{type = 'stat_add', stat = 'resistdamage', value = 50}],
		buffs = [{
				icon = "res://assets/images/iconsskills/tackle.png", 
				description = "BUFF_SCROLL_DEFENCE",
				limit = 1,
				t_name = 'icon_scroll_defence',
				bonuseffect = 'duration'
			}
		],
	},
#	e_test_trigger = {
#			type = 'trigger',
#			trigger = [variables.TR_COMBAT_S],
#			conditions = [],
#			req_skill = false,
#			sub_effects = ['e_test_aura'],
#			buffs = []
#		},
#	e_test_aura = {
#		type = 'aura',
#		target = 'owner',
#		conditions = [{type = 'stats', stat = 'position', operant = 'neq', value = null}], 
#		tags = ['buff'],
#		sub_effects = [],
#		atomic = [{type = 'stat_add', stat = 'damage', value = 50}],
#		buffs = [
#			{ #not this
#				icon = "res://assets/images/iconsskills/defaultattack.png", 
#				description = "Increase Damage by 50%%",
#				limit = 1,
#				t_name = 'e_i_defup'
#			}
#		],
#	},
	#passives
	e_tr_rose = { #rose personal weapon trait
		type = 'trigger',
		trigger = [variables.TR_KILL],
		conditions = [
			{type = 'owner', value = [{type = 'gear_level', slot = 'weapon1', level = 2, op = 'gte'}] },
		],
		req_skill = false,
		sub_effects = [
			{
				type = 'oneshot',
				target = 'owner',
				atomic = [{type = 'tick_cd'}],
				sub_effects = []
			},
		],
		buffs = []
	},
#	e_tr_erica = { #erica weapon2 lvl3+ static trait
#		type = 'static',
#		atomic = [{type = 'remove_skill', skill = 'nat_bless'}],
#		buffs = [],
#		sub_effects = [{
#			type = 'trigger',
#			trigger = [variables.TR_COMBAT_S],
#			conditions = [],
#			req_skill = false,
#			sub_effects = [
#				{
#					type = 'oneshot',
#					target = 'owner',
#					atomic = [{type = 'use_combat_skill', skill = 'nat_bless_pass'}],
#					sub_effects = []
#				},
#			],
#			buffs = []
#		}],
#	},
	e_tr_erica = {
		type = 'trigger',
		debug_name = "starter_passive_nature_bless",
		trigger = [variables.TR_COMBAT_S],
		conditions = [
			{type = 'owner', value = [{type = 'gear_level', slot = 'weapon2', level = 3, op = 'gte'}] },
		],
		req_skill = false,
		sub_effects = ['e_aura_erica'],
		buffs = []
	},
	e_aura_erica = {
		type = 'aura',
		debug_name = "passive_nature_bless",
		target = 'owner',
		conditions = [
#			{type = 'skill', skill = 'nat_bless', check = 'disabled'},
#			{type = 'stats', stat = 'position', operant = 'neq', value = null}
			], 
		tags = ['buff'],
		sub_effects = [],
		atomic = [
			{type = 'stat_add', stat = 'hitrate', value = 20},
			{type = 'stat_add_p', stat = 'damage', value = 0.20},
		],
		buffs = [{ 
			icon = "res://assets/images/iconsskills/erika_1.png", 
			description = "BUFF_NATURE_BLESS",
			t_name = 'icon_passive_bless'
		}],
	},
	e_tr_ember = {#ember weapon1 lvl3+ static trait
		type = 'trigger',
		debug_name = "starter_passive_damage_mul",
		trigger = [variables.TR_COMBAT_S],
		conditions = [
			{type = 'owner', value = [{type = 'gear_level', slot = 'weapon1', level = 3, op = 'gte'}] },
		],
		req_skill = false,
		sub_effects = ['e_ember_damage_mul'],
		buffs = []
	},
	e_ember_damage_mul = {
		type = 'static',
		debug_name = "passive_damage_mul",
		target = 'owner',
		atomic = [{type = 'stat_mul', stat = 'damage', value = 1.2}],
		buffs = [{
			icon = "res://assets/images/iconsskills/defaultattack.png", 
			description = "BUFF_PASSIVE_DAMAGE",
			t_name = 'icon_passive_damage'
		}],
		sub_effects = [],
	},
	e_tr_rilu = {#rilu traits
		type = 'static',
		debug_name = "souls_processor",
		tags = ['recheck_alt_mana'],
		args = [{obj = 'app_obj', param = 'alt_mana', dynamic = true}],
		sub_effects = ['e_t_souls', 'e_h_souls', 'e_at_souls', 'e_tr_d_souls'],
		atomic = [],
		buffs = [{
			icon = "res://assets/images/traits/speedondamage.png",
			description = "BUFF_SOULS",
			args = [{obj = 'parent_args', param = 0}],
			t_name = 'icon_souls',
			limit = 1,
			bonuseffect = 'arg', bonusarg = 0
		}],
		sfx = [
			{code = "rilu_spirit_1",
			conditions = [{type = 'owner', value = {type = 'stats', stat = 'alt_mana', value = 1, operant = 'gte'}}],
			id = 'sfx_souls_1',
			},
			{code = "rilu_spirit_2",
			conditions = [{type = 'owner', value = {type = 'stats', stat = 'alt_mana', value = 2, operant = 'gte'}}],
			id = 'sfx_souls_2',
			},
			{code = "rilu_spirit_3",
			conditions = [{type = 'owner', value = {type = 'stats', stat = 'alt_mana', value = 3, operant = 'gte'}}],
			id = 'sfx_souls_3',
			},
		],
	},
	e_t_souls = {
		type = 'trigger',
		debug_name = "souls_cleaner",
		trigger = [variables.TR_COMBAT_F],
		conditions = [],
		req_skill = false,
		sub_effects = [
			{
				type = 'oneshot',
				target = 'owner',
				atomic = ['a_souls_clean']
			},
		],
		buffs = []
	},
	e_tr_d_souls = {
		type = 'trigger',
		debug_name = "starter_souls_damage",
		trigger = [variables.TR_COMBAT_S],
		conditions = [
			{type = 'owner', value = [{type = 'gear_level', slot = 'weapon1', level = 2, op = 'gte'}] },
		],
		req_skill = false,
		sub_effects = ['e_d_souls'],
		buffs = []
	},
	e_d_souls = {
		type = 'dynamic',
		debug_name = "souls_damage",
		target = 'owner',
		args = [{obj = 'app_obj', param = 'alt_mana', dynamic = true}],
		atomic = [{type = 'stat_add_p', stat = 'damage', value = [['parent_args', 0],'*', 0.1]}],
		tags = ['recheck_stats', 'recheck_alt_mana'],
		buffs = [{
			icon = "res://assets/images/traits/critrate.png",
			description = "WEAPON_RILU1_EFFECT2",
			t_name = 'icon_souls_damage',
			limit = 1
		}],
		sub_effects = []
	},
#	e_s_souls = {#old concept
#		type = 'dynamic',
#		debug_name = "souls_buff",
#		args = [{obj = 'parent_args', param = 0}],
#		atomic = [
#			{type = 'stat_add_p', stat = 'damage', value = [['parent_args', 0],'*', 0.08]},
#			{type = 'stat_add', stat = 'resistdamage', value = [['parent_args', 0],'*',5]}],
#		tags = ['recheck_stats'],
#		buffs = [],
#		sub_effects = []
#	},
	e_h_souls = {
		type = 'trigger',
		debug_name = "souls_heal",
		trigger = [variables.TR_POSTDAMAGE],
		conditions = [
			{type = 'skill', value = ['tags', 'has', 'damage']},
			{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]},
		],
		req_skill = true,
		args = [
			{obj = 'parent_args', param = 0, dynamic = true},
			{obj = 'skill', param = 'damage_dealt_hp', dynamic = true}],
		sub_effects = [{
			type = 'oneshot',
			target = 'owner',
			args = [
				{obj = 'parent_args', param = 0},
				{obj = 'parent_args', param = 1}],
			atomic = [
				{type = 'heal', value = [['parent_args',1],'*',0.3,'*',['parent_args',0]]},
				{type = 'sfx', value = 'sfx_soul_prot'}],
		}],
		buffs = []
	},
	e_at_souls = {
		type = 'trigger',
		debug_name = "souls_obtainer",
		trigger = [variables.TR_TURN_S],
		conditions = [],
		req_skill = false,
		sub_effects = ['e_add_s'],
		buffs = []
		#old concept
#		trigger = [variables.TR_POST_TARG],
#		conditions = [
#			{type = 'skill', value = ['tags', 'has', 'damage']},
#			{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]},
##			{type = 'random', value = 0.5}#that probably should be 100% chance
#			],
#		req_skill = true,
	},
#	e_sc_souls = {#old concept
#		type = 'trigger',
#		debug_name = "souls_at_start",
#		trigger = [variables.TR_COMBAT_S],
#		conditions = [],
#		req_skill = false,
#		sub_effects = ['e_add_s'],
#		buffs = []
#	},
	e_add_s = {
		type = 'oneshot',
		target = 'owner',
		atomic = ['a_souls_add']
	},
	#not in use
#	e_add_s1 = {
#		type = 'oneshot',
#		target = 'caster',
#		atomic = ['a_souls_add']
#	},
	e_pay_soul = {
		type = 'trigger',
		debug_name = "pay_soul",
		trigger = [variables.TR_CAST],
		conditions = [],
		req_skill = true,
		sub_effects = [
			{
				type = 'oneshot',
				target = 'caster',
				atomic = [{type = 'stat_add', stat = 'alt_mana', value = -1}]
			},
		],
		buffs = []
	},
	e_pay_all_souls = {
		type = 'trigger',
		debug_name = "pay_all_souls",
		trigger = [variables.TR_SKILL_FINISH],
		conditions = [],
		req_skill = true,
		sub_effects = [
			{
				type = 'oneshot',
				target = 'caster',
				atomic = ['a_souls_clean']
			},
		],
		buffs = []
	},
	e_add_all_souls = {
		type = 'trigger',
		debug_name = "add_all_souls",
		trigger = [variables.TR_SKILL_FINISH],
		conditions = [],
		req_skill = true,
		sub_effects = [{
			type = 'oneshot',
			target = 'caster',
			atomic = ['a_souls_add', 'a_souls_add', 'a_souls_add']
		}],
		buffs = []
	},
	
#	e_tr_enable_fa = {
#		type = 'trigger',
#		trigger = [variables.TR_KILL],
#		conditions = [],
#		req_skill = true,
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'combat',
#				execute = 'enable_followup'
#			},
#		],
#		buffs = []
#	},
	
	e_tr_bloodlust = {
		type = 'trigger',
		debug_name = 'bloodlust_starter',
		trigger = [variables.TR_TURN_F],
		conditions = [],
		req_skill = false,
		sub_effects = ['e_bloodlust'],
		buffs = []
	},
	e_bloodlust = {#dwarf king rage of stage 1
		type = 'temp_s',
		screen_name = 'EF_BLOODLUST',
		name = 'bloodlust',
		target = 'owner',
		stack = 5,
		tags = ['buff'],
		icon_text = "10",
		args = [{obj = 'template', param = 'icon_text'}],
		sub_effects = [],
		atomic = [{type = 'stat_add_p', stat = 'damage', value = 0.1}],
		buffs = ['b_bloodlust'],
	},
	e_tr_rage = {
		type = 'trigger',
		debug_name = 'rage_starter',
		trigger = [variables.TR_TURN_F],
		conditions = [],
		req_skill = false,
		sub_effects = ['e_rage'],
		buffs = []
	},
	e_rage = {#dwarf king rage of stage 2
		type = 'temp_s',
		screen_name = 'EF_RAGE',
		name = 'rage',
		target = 'owner',
		stack = 5,
		tags = ['buff', 'rage'],
		icon_text = "20",
		args = [{obj = 'template', param = 'icon_text'}],
		sub_effects = [],
		atomic = [{type = 'stat_add_p', stat = 'damage', value = 0.2}],
		buffs = ['b_enrage'],
	},
	e_dispel_rage = { #for both dwarwenking and dwarves
		type = 'trigger',
		debug_name = "dwarf_enrage_dispel",
		trigger = [variables.TR_POST_TARG],
		conditions = [
			{type = 'skill', value = ['damagetype','eq', 'water'] },
			{type = 'skill', value = ['hit_res','mask',variables.RES_HITCRIT] }
		],
		req_skill = true,
		args = [],
		sub_effects = [{
			type = 'oneshot',
			target = 'owner',
			atomic = [{type = 'remove_all_effects', value = 'rage'}]
		}],
		buffs = []
	},
	e_tr_rage_1 = {#regular dwarf rage
		type = 'trigger',
		debug_name = "dwarf_enrage_starter",
		trigger = [variables.TR_POST_TARG],
		conditions = [
			{type = 'skill', value = ['tags','has', 'damage'] },
			{type = 'skill', value = ['hit_res','mask',variables.RES_HITCRIT] }
		],
		req_skill = true,
		sub_effects = ['e_rage_1'],
		buffs = []
	},
	e_rage_1 = {
		type = 'temp_s',
		screen_name = 'EF_RAGE',
		name = 'dwarf_enrage',
		target = 'owner',
		stack = 0,
		tags = ['buff', 'rage'],
		icon_text = "5",
		args = [{obj = 'template', param = 'icon_text'}],
		sub_effects = [],
		atomic = [{type = 'stat_add_p', stat = 'damage', value = 0.05}],
		buffs = ['b_enrage'],
	},
	e_s_execute_charge = {
		type = 'temp_s',
		screen_name = 'EF_EXECUTE_CHARGE',
		name = 'execute_charge',
		target = 'caster',
		stack = 1,
		tick_event = [variables.TR_TURN_F],
		duration = 2,
		tags = ['execute_charged'],#status for AI to add dk_execute skill
		args = [],
		sub_effects = [],
		atomic = [],
		buffs = [{
			icon = "res://assets/images/iconsskills/strongattack.png", 
			description = "BUFF_EXECUTE_CHARGE",
			limit = 1,
			t_name = 'icon_execute_charge'
		}],
	},
	e_execute_heal = {
		type = 'temp_s',
		name = 'execute_heal_timer',
		target = 'caster',
		stack = 1,
		rem_event = variables.TR_TURN_F,
		tags = [],
		args = [{obj = 'parent_args', param = 0}],
		sub_effects = ['e_execute_healer'],
		atomic = [],
		buffs = [],
	},
	e_execute_healer = {
		type = 'trigger',
		debug_name = 'execute_healer',
		trigger = [variables.TR_KILL],
		req_skill = false,
		conditions = [],
		args = [{obj = 'parent_args', param = 0}],
		sub_effects = [{
			type = 'oneshot',
			target = 'owner',
			args = [{obj = 'parent_args', param = 0}],
			atomic = [{type = 'heal', value = ['parent_args', 0]}],
		}],
		buffs = []
	},
	e_tr_fq = {
		type = 'trigger',
		debug_name = 'faery_barrier',
		trigger = [variables.TR_TURN_S],
		conditions = [],
		req_skill = false,
		sub_effects = [{
			type = 'oneshot',
			target = 'owner',
			args = [{obj = 'app_obj', param = 'ai_spec'}],
			atomic = [{type = 'stat_add', stat = 'shield', value = [['parent_args', 0], '*', 25]}],
			sub_effects = []
		}],
		args = [{obj = 'app_obj', param = 'shield', dynamic = true}],
		buffs = [{
			icon = "res://assets/images/traits/armor.png", 
			description = "BUFF_FAERY_BARRIER",
			args = [{obj = 'parent_args', param = 0}],
			t_name = 'icon_faery_barrier',
		}],
	},
	e_fq_blast_info = {
		type = 'static',
		debug_name = 'fqueen_blast_info',
		args = [],
		buffs = [{
			icon = "res://assets/images/iconsskills/erika_5.png", 
			description = "BUFF_FQUEEN_BLAST_INFO",
			t_name = 'icon_fqueen_blast_info',
		}],
		sub_effects = [],
	},
	e_s_suicide = {
		type = 'oneshot',
		target = 'target',
		conditions = [
			{type = 'stats', stat = 'base', value = 'bomber', operant = 'neq' } 
		],
		args = [{obj = 'parent_args', param = 0}],
		atomic = ['a_burn']
	},
	e_tr_unstable = {
		type = 'static',
		debug_name = 'unstable_bomber',
		atomic = [],
		buffs = [{
			icon = "res://assets/images/iconsskills/unstable.png", 
			description = "BUFF_UNSTABLE",
			t_name = 'icon_unstable'
		}],
		sub_effects = ['e_d_bomb1', 'e_d_bomb2'],
	},
	e_d_bomb1 = {
		type = 'trigger',
		debug_name = 'bomber_on_player',
		conditions = [{type = 'combat', value = {type = 'is_player_turn'}}],
		trigger = [variables.TR_DEATH],
		req_skill = false,
		sub_effects = [{
			type = 'oneshot',
			target = 'owner',
			atomic = [{type = 'use_combat_skill', skill = 'bomb_cond1'}],
		}],
		buffs = []
	},
	e_d_bomb2 = {
		type = 'trigger',
		debug_name = 'bomber_on_enemy',
		conditions = [{type = 'combat', value = {type = 'is_enemy_turn'}}],
		trigger = [variables.TR_DEATH],
		req_skill = false,
		sub_effects = [{
			type = 'oneshot',
			target = 'owner',
			atomic = [{type = 'use_combat_skill', skill = 'bomb_cond2'}],
		}],
		buffs = []
	},
	e_dim_soulprot = {
		type = 'static',
		debug_name = 'demitrius_soulprot',
		tags = ['soulprot'],
		sub_effects = [],
		atomic = [],
		buffs = []
	},
	e_dim_hp_1 = {
		type = 'c_static',
		debug_name = 'rule_no_barriers',
		conditions = [{type = 'stats', stat = 'hp_p', operant = 'lt', value = 99}],
		tags = ['recheck_damage'],
#		no_escape = true,
		atomic = [{type = 'add_rule', value = 'no_shield'}],
		buffs = [{
			icon = "res://assets/images/iconsskills/blood_blue.png", 
			description = "BUFF_RULE_NO_BARRIERS",
			limit = 1,
			t_name = 'icon_rule_no_barriers'
		}],
		sub_effects = [],
	},
	e_dim_hp_2 = {
		type = 'c_static',
		debug_name = 'rule_no_heal',
		conditions = [{type = 'stats', stat = 'hp_p', operant = 'lt', value = 75}],
		tags = ['recheck_damage'],
#		no_escape = true,
		atomic = [{type = 'add_rule', value = 'no_heal'}],
		buffs = [{
			icon = "res://assets/images/iconsskills/blood_blue.png", 
			description = "BUFF_RULE_NO_HEAL",
			limit = 1,
			t_name = 'icon_rule_no_heal'
		}],
		sub_effects = [],
	},
	e_dim_hp_3 = {
		type = 'c_static',
		debug_name = 'rule_no_res',
		conditions = [{type = 'stats', stat = 'hp_p', operant = 'lt', value = 40}],
		tags = ['recheck_damage'],
#		no_escape = true,
		atomic = [{type = 'add_rule', value = 'no_res'}],
		buffs = [{
			icon = "res://assets/images/iconsskills/blood_blue.png", 
			description = "BUFF_RULE_NO_RES",
			limit = 1,
			t_name = 'icon_rule_no_res'
		}],
		sub_effects = [],
	},
	e_dim_resists = {
		type = 'trigger',
		debug_name = 'resist_shuffler',
		conditions = [],
		trigger = [variables.TR_HIT],
		req_skill = true,
		sub_effects = [{
			type = 'oneshot',
			target = 'caster',
			atomic = [{type = 'ai_call', value = 'shuffle_resists'}],
		}],
		buffs = []
	},
	
	e_summon_clean = {
		type = 'trigger',
		debug_name = 'summon_cleaner',
		trigger = [variables.TR_DEATH],
		conditions = [],
		req_skill = false,
		sub_effects = [{
			type = 'oneshot',
			target = 'combat',
			execute = 'clean_summons',
		}]
	},
	#e_i_barrier4_timer and e_i_barrier5_timer has to be different effects, so shields and buff icons could cooperate
	e_i_barrier4 = {
		type = 'trigger',
		debug_name = "item_barrier_3_starter",
		trigger = [variables.TR_HIT],
		req_skill = true,
		conditions = [],
		args = [{obj = 'parent', param = 'process_value'}],
		sub_effects = ['e_i_barrier4_timer'],
		buffs = []
	},
	e_i_barrier4_timer = {
		type = 'temp_s',
		screen_name = 'EF_BARRIER',
		name = 'item_barrier_3',
		target = 'target',
		tick_event = variables.TR_TURN_S,#or get
		rem_event = variables.TR_SHIELD_DOWN,
		duration = 3,
		stack = 1,
		args = [{obj = 'parent_args', param = 0}, {obj = 'app_obj', param = 'shield', dynamic = true}],
		atomic = [{type = 'shield_add_temporal', shield_id = 'barrier4', value = ['parent_args', 0]}],
		buffs = ['b_barrier'],
		sub_effects = [],
	},
	e_i_barrier5 = {
		type = 'trigger',
		debug_name = "item_barrier_2_starter",
		trigger = [variables.TR_HIT],
		req_skill = true,
		conditions = [],
		args = [{obj = 'parent', param = 'process_value'}],
		sub_effects = ['e_i_barrier5_timer'],
		buffs = []
	},
	e_i_barrier5_timer = {
		type = 'temp_s',
		screen_name = 'EF_BARRIER',
		name = 'item_barrier_2',
		target = 'target',
		tick_event = variables.TR_TURN_S,#or get
		rem_event = variables.TR_SHIELD_DOWN,
		duration = 2,
		stack = 1,
		args = [{obj = 'parent_args', param = 0}, {obj = 'app_obj', param = 'shield', dynamic = true}],
		atomic = [{type = 'shield_add_temporal', shield_id = 'barrier5', value = ['parent_args', 0]}],
		buffs = ['b_barrier'],
		sub_effects = [],
	},
	common_shield_info = {
		type = 'temp_s',#this should be endless "temporal" effect
		screen_name = 'EF_SHIELD',
		name = 'common_shield_info',
		rem_event = variables.TR_SHIELD_DOWN,
		target = 'target',
		stack = 1,
		args = [{obj = 'app_obj', param = 'shield', dynamic = true}],
		buffs = [{
				icon = "res://assets/images/traits/armor.png", 
				description = "BUFF_SHIELD_INFO",
				args = [{obj = 'parent_args', param = 0}],
				t_name = 'icon_shield_info',
			}
		],
		sub_effects = [],
	},
	
	
	
	
	
	
	#old part
	#all of this are either too old, replaced, or not in use anymore. Delete them in time (since 3.12.23), if nothing breaks
	#traits
#	e_tr_dmgbeast = {
#		type = 'trigger',
#		trigger = [variables.TR_HIT],
#		req_skill = true,
#		conditions = [
#			{type = 'target', value = {type = 'race', value = 'animal' } }
#		],
#		atomic = [],
#		buffs = [],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'skill',
#				atomic = [{type = 'stat_mul', stat = 'value', value = 1.2}],
#				buffs = [],
#				sub_effects = []
#			}
#		]
#	},
#	e_tr_nodmgbeast = {
#		type = 'trigger',
#		trigger = [variables.TR_DEF],
#		req_skill = true,
#		conditions = [
#			{type = 'caster', value = {type = 'race', value = 'animal' } }
#		],
#		atomic = [],
#		buffs = [],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'skill',
#				atomic = [{type = 'stat_mul', stat = 'value', value = 0.8}],
#				buffs = [],
#				sub_effects = []
#			}
#		]
#	},
#	e_tr_fastlearn = { #no icon for buff as this is the only effect of trait. can add if reqired
#		type = 'static',
#		atomic = [{type = 'stat_add', stat = 'xpmod', value = 0.15}],#xpmod stat_add probably doesn't work
#		buffs = [],
#		sub_effects = [],
#	},
#	e_tr_hitrate = {#no icon for buff as this is the only effect of trait. can add if reqired
#		type = 'static',
#		atomic = [{type = 'stat_add', stat = 'hitrate', value = 10}],
#		buffs = [],
#		sub_effects = [],
#	},
#	e_tr_ev10 = {#no icon for buff as this is the only effect of trait. can add if reqired
#		type = 'static',
#		atomic = [{type = 'stat_add', stat = 'evasion', value = 10}],
#		buffs = [],
#		sub_effects = [],
#	},
#	e_tr_ev15 = {#no icon for buff as this is the only effect of trait. can add if reqired
#		type = 'static',
#		atomic = [{type = 'stat_add', stat = 'evasion', value = 15}],
#		buffs = [],
#		sub_effects = [],
#	},
#	e_tr_crit = {#no icon for buff as this is the only effect of trait. can add if reqired
#		type = 'static',
#		atomic = [{type = 'stat_add', stat = 'critchance', value = 10}],
#		buffs = [],
#		sub_effects = [],
#	},
#	e_tr_resist = {#no icon for buff as this is the only effect of trait. can add if reqired
#		type = 'static',
#		atomic = [
#			{type = 'stat_add', stat = 'resistfire', value = 10},
#			{type = 'stat_add', stat = 'resistair', value = 10},
#			{type = 'stat_add', stat = 'resistwater', value = 10},
#			{type = 'stat_add', stat = 'resistearth', value = 10},
#		],
#		buffs = [],
#		sub_effects = [],
#	},
#	e_tr_armor = {#no icon for buff as this is the only effect of trait. can add if reqired
#		type = 'static',
##		atomic = [{type = 'stat_add', stat = 'armor', value = 5}],
#		buffs = [],
#		sub_effects = [],
#	},
#	e_tr_hpmax = {#no icon for buff as this is the only effect of trait. can add if reqired
#		type = 'static',
#		atomic = [{type = 'stat_add', stat = 'hpmax', value = 25}],
#		buffs = [],
#		sub_effects = [],
#	},
#	e_tr_speed = {#no icon for buff as this is the only effect of trait. version with icon exists too
#		type = 'static',
#		atomic = [{type = 'stat_add', stat = 'speed', value = 10}],#speed stat seems not exist
#		buffs = [],
#		sub_effects = [],
#	},
#	e_tr_regen = {#no icon for buff as this is the only effect of trait. can add if reqired
#		type = 'trigger',
#		req_skill = false,
#		trigger = [variables.TR_TURN_F],
#		conditions = [],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'owner',
#				atomic = [{type = 'stat_add', stat = 'hppercent', value = 5}],#hppercent stat seems not exist
#				buffs = [],
#				sub_effects = []
#			}
#		],
#		buffs = []
#	},
#	e_tr_noevade = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_POSTDAMAGE],
#		conditions = [],
#		sub_effects = ['e_t_noevade10'],
#		atomic = [],
#		buffs = [],
#	},
#	e_t_noevade10 = {
#		type = 'temp_s',
#		target = 'target',
#		name = 'noevade10',
#		tags = ['neg_state'],
#		tick_event = variables.TR_TURN_S,
#		rem_event = variables.TR_COMBAT_F,
#		duration = 2,
#		stack = 1,
#		sub_effects = [],
#		atomic = [{type = 'stat_add', stat = 'evasion', value = -10}],
#		buffs = [
#			{
#				icon = "res://assets/images/traits/dodgedebuff.png", 
#				description = "Evasion reduced by 10",
#				args = [],
#				t_name = 'eva10'
#			}
#		],
#	},
#	e_tr_prot_a = {
#		type = 'static',
#		atomic = [],
#		buffs = [
#			{#for testing purpose
#				icon = "res://assets/images/traits/armorgroup.png", 
#				description = "This unit owns area protection effect",
#				t_name = 'areaprot1'
#			}
#		],
#		sub_effects = ['e_tr_areaprot'],
#	},
#	e_tr_areaprot = {
#		type = 'area',
#		area = 'back',
##		atomic = [{type = 'stat_add', stat = 'armor', value = 10}],
#		buffs = [
#			{#for testing purpose
#				icon = "res://assets/images/traits/armorgroup.png", 
#				description = "This unit's armor is increased by area effect ",
#				t_name = 'areaprot2'
#			}
#		],
#		sub_effects = [],
#	},
#	e_tr_healer = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_POSTDAMAGE],
#		conditions = [{type = 'skill', value = ['tags', 'has', 'type_heal']}],
#		args = [{obj = 'self', param = 'skill'}],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'caster',
#				args = [{obj = 'parent_args', param = 0}],
#				atomic = ['a_caster_heal'],
#				buffs = [],
#				sub_effects = []
#			}
#		],
#		buffs = []
#	},
#	e_tr_react = {
#		type = 'trigger',
#		req_skill = false,
#		trigger = [variables.TR_DMG],
#		conditions = [],
#		sub_effects = ['e_t_react'],
#		buffs = [],
#	},
#	e_t_react = {
#		type = 'temp_s',
#		target = 'owner',
#		name = 'react20',
#		tags = ['pos_state'],
#		tick_event = variables.TR_TURN_S,
#		rem_event = variables.TR_COMBAT_F,
#		duration = 2,
#		stack = 1,
#		sub_effects = [],
#		atomic = [{type = 'stat_add', stat = 'speed', value = 20}],
#		buffs = [
#			{
#				icon = "res://assets/images/traits/speedondamage.png", 
#				description = "Speed increased by 20",
#				args = [{obj = 'parent', param = 'remains'}],
#				t_name = 'react'
#			}
#		],
#	},
#	e_tr_magecrit = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_POSTDAMAGE],
#		reset = [variables.TR_CAST],
#		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_CRIT]}],
#		args = [{obj = 'self', param = 'skill'}],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'caster',
#				args = [{obj = 'parent_args', param = 0}],
#				atomic = ['a_magecrit'],
#				buffs = [],
#				sub_effects = []
#			}
#		],
#		buffs = []
#	},
#	e_tr_slowarrow = {
#		type = 'trigger',
#		trigger = [variables.TR_POSTDAMAGE],
#		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}],
#		req_skill = true,
#		sub_effects = ['e_t_slowarrow'],
#		buffs = []
#	},
#	e_t_slowarrow = {
#		type = 'temp_s',
#		target = 'target',
#		name = 'slowarrow',
#		tick_event = variables.TR_TURN_S,
#		rem_event = variables.TR_COMBAT_F,
#		duration = 2,
#		stack = 2,
#		tags = ['natural_debuf'],
#		sub_effects = [],
#		atomic = [
#			{type = 'stat_add', stat = 'speed', value = -10},
#			{type = 'stat_add', stat = 'evasion', value = -10}
#		],
#		buffs = [
#			{
#				icon = "res://assets/images/traits/speeddebuf.png", 
#				description = "Speed and evasion reduced",
#				limit = 1,
#				t_name = 'slowarrow'
#			}
#		],
#	},
#	e_tr_killer = {
#		type = 'trigger',
#		req_skill = false,
#		trigger = [variables.TR_KILL],
#		reset = [variables.TR_CAST],
#		conditions = [],
#		sub_effects = ['e_t_killer'],
#		buffs = []
#	},
#	e_t_killer = {
#		target = 'owner',
#		type = 'temp_s',
#		template_name = 'killerbuf',
#		sub_effects = ['e_t_killer2'],
#		stack = 1,
#		rem_event = variables.TR_COMBAT_F,
#		buffs = [
#			{
#				icon = "res://assets/images/traits/bowextradamage.png", 
#				description = "This unit's next attack will do double damage to its first target",
#				t_name = 'killerbuf'
#			}
#		],
#	},
#	e_t_killer2 = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_HIT],
#		reset = [variables.TR_CAST],
#		ready = false,#for the reason not to trigger on the same area attack as initial kill
#		conditions = [{type = 'skill', value = ['skilltype', 'eq', 'skill']}],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'skill',
#				atomic = [{type = 'stat_mul', stat = 'value', value = 2}],
#				buffs = [],
#				sub_effects = []
#			},
#			{
#				type = 'oneshot',
#				target = 'parent',
#				execute = 'remove'
#			}
#		]
#	},
#	e_tr_rangecrit = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_HIT],
#		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_CRIT]}],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'skill',
##				atomic = [{type = 'stat_set', stat = 'armor_p', value = 10000}],
#				buffs = [],
#				sub_effects = []
#			}
#		],
#		buffs = []
#	},
#	e_tr_speed_a = {
#		type = 'static',
#		atomic = [],
#		buffs = [
#			{#for testing purpose
#				icon = "res://assets/images/traits/dodgegroup.png", 
#				description = "This unit owns area speed increasing effect",
#				t_name = 'areaspeed1'
#			}
#		],
#		sub_effects = ['e_tr_areaspeed'],
#	},
#	e_tr_areaspeed = {
#		type = 'area',
#		area = 'line',
#		atomic = [{type = 'stat_add', stat = 'speed', value = 10}],#i'm still confused if this buff should increase speed or evasion....
#		buffs = [
#			{#for testing purpose
#				icon = "res://assets/images/traits/dodgegroup.png", 
#				description = "This unit's speed is increased by area effect ",
#				t_name = 'areaspeed2'
#			}
#		],
#		sub_effects = [],
#	},
#	e_tr_noresist = {
#		type = 'trigger',
#		conditions = [],
#		trigger = [variables.TR_HIT],
#		req_skill = true,
#		sub_effects = ['e_t_noresist'],
#		buffs = []
#	},
#	e_t_noresist = {
#		type = 'temp_s',
#		target = 'target',
#		name = 'noresist',
#		tags = ['curse'],
#		tick_event = variables.TR_TURN_S,
#		rem_event = variables.TR_COMBAT_F,
#		duration = 1,
#		stack = 1,
#		sub_effects = [],
#		atomic = [
#			{type = 'stat_add', stat = 'resistfire', value = -15},
#			{type = 'stat_add', stat = 'resistair', value = -15},
#			{type = 'stat_add', stat = 'resistwater', value = -15},
#			{type = 'stat_add', stat = 'resistearth', value = -15},
#		],
#		buffs = [
#			{
#				icon = "res://assets/images/traits/resistdebuf.png", 
#				description = "All Resists are reduced by 15",
#				limit = 1,
#				t_name = 'noresist'
#			}
#		],
#	},
#	e_tr_firefist = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_POSTDAMAGE],
#		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}],
#		args = [{obj = 'self', param = 'skill'}],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'target',
#				args = [{obj = 'parent_args', param = 0}],
#				atomic = ['a_firefist'],
#				buffs = [],
#				sub_effects = []
#			}
#		],
#		buffs = []
#	},
#	e_tr_necro = {
#		type = 'static',
#		sub_effects = ['e_tr_necro_clean'],
#		atomic = ['a_souls1', 'a_souls2'],
#		buffs = ['b_souls'],
#		args = [{obj = 'app_obj', param = 'alt_mana', dynamic = true}]
#	},
#	e_tr_necro_clean = {
#		type = 'trigger',
#		req_skill = false,
#		trigger = [variables.TR_COMBAT_F],
#		conditions = [],
#		atomic = [],
#		buffs = [],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'owner',
#				atomic = [
#					{type = 'stat_set', stat = 'alt_mana', value = 0}
#				],
#				buffs = [],
#				sub_effects = []
#			}
#		]
#	},
	#monstertraits
#	e_tr_elheal = {
#		type = 'trigger',
#		trigger = [variables.TR_TURN_GET],
#		req_skill = false,
#		conditions = [],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'owner',
#				atomic = [{type = 'heal', stat = 'hp', value = 20}],
#				sub_effects = []
#			}
#		]
#	},
#	e_tr_dwarwenbuf = {#pattern for buffs with limited but not defined duration
#		type = 'trigger',
#		conditions = [],
#		trigger = [variables.TR_DMG],
#		req_skill = false,
#		sub_effects = ['e_t_dwarwenbuf'],
#		buffs = []
#	},
#	e_t_dwarwenbuf = {
#		type = 'temp_s',
#		target = 'owner',
#		name = 'dwarvenbuf',
#		rem_event = variables.TR_COMBAT_F,
#		stack = 0,
#		sub_effects = [],
#		atomic = [
#			{type = 'stat_add', stat = 'damage', value = 5},
#		],
#		buffs = [
#			{
#				icon = "res://assets/images/traits/beastdamage.png", 
#				description = "Damage increased by 5 per stack",
#				limit = 1,
#				t_name = 'dwarwenbuf'
#			}
#		],
#	},
#	e_tr_treant_barrier = {
#		type = 'trigger',
#		trigger = [variables.TR_TURN_GET],
#		req_skill = false,
#		conditions = [],
#		sub_effects = [
#			{
#				type = 'temp_s',
#				target = 'owner',
#				tick_event = variables.TR_TURN_GET,
#				rem_event = [variables.TR_SHIELD_DOWN,variables.TR_COMBAT_F],
#				duration = 1,
#				stack = 1,
#				name = 'treant_shield',
#				atomic = [
#					{type = 'shield_add_temporal', shield_id = 'treant_barrier', value = 15},
##					{type = 'stat_set_revert', stat = 'shieldtype', value = variables.S_PHYS}
#					],
#				buffs = [
#					{
#						icon = "res://assets/images/traits/armor.png", 
#						description = "Damage-absorbing shield, blocks 15 phys damage, regenerates every turn",
#						limit = 1,
#						t_name = 'treant_shield'
#					}
#				],
#				sub_effects = [],
#			}
#		],
#		buffs = []
#	},
	
	#skills
#	e_s_stun05 = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_POSTDAMAGE],
#		conditions = [
#			{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]},
#			{type = 'random', value = 0.5}
#		],
#		buffs = [],
#		sub_effects = ['e_stun']
#	},
#	e_s_stun = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_POSTDAMAGE],
#		conditions = [
#			{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}
#		],
#		buffs = [],
#		sub_effects = ['e_stun']
#	},
#	e_stun_alternate = { #template that can reset duration, no difference for one-turn effects but is an example for longer effects 
#		type = 'temp_s',
#		target = 'target',
#		stack = 1,
#		tick_event = [variables.TR_TURN_GET],
#		duration = 2,
#		rem_event = [variables.TR_COMBAT_F],
#		name = 'stun',
#		disable = true,
#		sub_effects = [],
#		atomic = [],
#		buffs = ['b_stun']
#	},
#	e_s_cripple = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_POSTDAMAGE],
#		conditions = [
#			{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}
#		],
#		buffs = [],
#		sub_effects = ['e_cripple']
#	},
#	e_cripple = {
#		type = 'temp_s',
#		target = 'target',
#		stack = 1,
#		tick_event = [variables.TR_TURN_F],
#		duration = 3,
#		rem_event = [variables.TR_COMBAT_F],
#		name = 'cripple',
#		tags = ['afflict'],
#		sub_effects = [],
#		atomic = [{type = 'stat_add_p', stat = 'damage', value = -0.33}],
#		buffs = [
#			{
#				icon = "res://assets/images/traits/speeddebuf.png", #TO FIX
#				description = "Damage reduced by 33%%",
#				args = [{obj = 'parent', param = 'remains'}],
#				t_name = 'cripple'
#			}
#		]
#	},
#	e_s_spidernoarmor = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_POSTDAMAGE],
#		conditions = [
#			{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}
#		],
#		buffs = [],
#		sub_effects = ['e_spider_noarmor']
#	},
#	e_spider_noarmor = {
#		type = 'temp_s',
#		target = 'target',
#		tick_event = [variables.TR_TURN_S],
#		duration = 2,
#		stack = 0,
#		rem_event = [variables.TR_COMBAT_F],
#		name = 'sp_noarm',
#		tags = ['natural_debuf'],
#		sub_effects = [],
##		atomic = [{type = 'stat_add', stat = 'armor', value = -10}],
#		buffs = [
#			{
#				icon = "res://assets/images/traits/armorignore.png", 
#				description = "Armor is reduced",
#				limit = 1,
#				t_name = 'sp_noarm'
#			}
#		]
#	},
#	e_s_taunt = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_POSTDAMAGE],
#		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}],
#		sub_effects = ['e_taunt'],
#		buffs = []
#	},
#	e_taunt = {
#		type = 'temp_s',
#		target = 'target',
#		stack = 1,
#		rem_event = [variables.TR_COMBAT_F, variables.TR_TURN_F],
#		name = 'taunt',
#		disable = true,
#		tags = ['afflict'],
#		sub_effects = [],
#		atomic = [{type = 'stat_add_p', stat = 'damage', value = -0.25}],
#		buffs = ['b_taunt']
#	},
#	e_s_quake = {
#		type = 'trigger',
#		trigger = [variables.TR_POSTDAMAGE],
#		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}],
#		req_skill = true,
#		sub_effects = ['e_t_quake'],
#		buffs = []
#	},
#	e_t_quake = {
#		type = 'temp_s',
#		target = 'target',
#		name = 'earthquake',
#		tick_event = variables.TR_TURN_S,
#		rem_event = variables.TR_COMBAT_F,
#		duration = 2,
#		stack = 1,
#		tags = ['natural_debuf'],
#		sub_effects = [],
#		atomic = [
#			{type = 'stat_add', stat = 'speed', value = -20},
#			{type = 'stat_add', stat = 'evasion', value = -20}
#		],
#		buffs = [
#			{
#				icon = "res://assets/images/traits/speeddebuf.png", #TO FIX
#				description = "Speed and Evasion reduced by 20",
#				limit = 1,
#				t_name = 'earthquake'
#			}
#		],
#	},
#	e_s_wwalk = {
#		type = 'trigger',
#		trigger = [variables.TR_HIT],
#		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}],
#		req_skill = true,
#		sub_effects = ['e_t_wwalk'],
#		buffs = []
#	},
#	e_t_wwalk = {
#		type = 'temp_s',
#		target = 'target',
#		name = 'wwalk',
#		tick_event = variables.TR_TURN_S,
#		rem_event = variables.TR_COMBAT_F,
#		duration = 3,
#		stack = 1,
#		tags = ['bless'],
#		sub_effects = [],
#		atomic = [
#			{type = 'stat_add', stat = 'speed', value = 15},
#			{type = 'stat_add', stat = 'hitrate', value = 25},
#			{type = 'stat_add', stat = 'evasion', value = 25}
#		],
#		buffs = ['b_wwalk'],
#	},
#	e_s_nbless = {
#		type = 'trigger',
#		trigger = [variables.TR_HIT],
#		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}],
#		req_skill = true,
#		sub_effects = ['e_t_nbless'],
#		buffs = []
#	},
#	e_t_nbless = {
#		type = 'temp_s',
#		target = 'target',
#		name = 'wwalk',
#		tick_event = variables.TR_TURN_F,
#		rem_event = variables.TR_COMBAT_F,
#		duration = 3,
#		stack = 1,
#		tags = ['bless'],
#		sub_effects = [
#			{
#				type = 'trigger',
#				trigger = [variables.TR_TURN_GET],
#				conditions = [],
#				req_skill = false,
#				sub_effects = [
#					{
#						type = 'oneshot',
#						target = 'owner',
#						atomic = [{type = 'stat_add', stat = 'hppercent', value = 20}],
#						sub_effects = []
#					}
#				],
#				buffs = []
#			}
#		],
#		atomic = [],
#		buffs = ['b_nbless'],
#	},
#	e_s_bcry = {
#		type = 'trigger',
#		trigger = [variables.TR_HIT],
#		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}],
#		req_skill = true,
#		sub_effects = ['e_t_bcry'],
#		buffs = []
#	},
#	e_t_bcry = {
#		type = 'temp_s',
#		target = 'target',
#		name = 'battlecry',
#		tick_event = variables.TR_TURN_S,
#		rem_event = variables.TR_COMBAT_F,
#		duration = 3,
#		stack = 1,
#		tags = ['bless'],
#		sub_effects = [],
#		atomic = [
#			{type = 'stat_add_p', stat = 'damage', value = 0.2}
#		],
#		buffs = [
#			{
#				icon = "res://assets/images/traits/speeddebuf.png", #TO FIX
#				description = "Damage increased",
#				limit = 1,
#				t_name = 'battlecry'
#			},
#		],
#	},
#	e_s_execute = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_KILL],
#		conditions = [],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'caster',
#				args = [{obj = 'app_obj', param = 'hpmax', dynamic = true}, {obj = 'app_obj', param = 'manamax', dynamic = true}],
#				atomic = ['a_hp_restore_ex','a_mana_restore_ex'],
#				buffs = [],
#				sub_effects = []
#			}
#		],
#		buffs = []
#	},
	#as like all shield effects this is not a final version
#	e_s_ward = {
#		type = 'trigger',
#		trigger = [variables.TR_HIT],
#		req_skill = true,
#		conditions = [],
#		args = [{obj = 'self', param = 'skill'}],
#		sub_effects = [
#			{
#				type = 'temp_s',
#				target = 'target',
#				tick_event = variables.TR_TURN_GET,
#				rem_event = [variables.TR_SHIELD_DOWN,variables.TR_COMBAT_F],
#				duration = 3,
#				stack = 1,
#				name = 'ward',
#				atomic = [
#					'a_ward_shield',
##					{type = 'stat_set_revert', stat = 'shieldtype', value = variables.S_FULL}
#					],
#				args = [{obj = 'app_obj', param = 'shield', dynamic = true},{obj = 'parent_arg_get', index = 0, param = 'process_value'}],
#				buffs = [
#					{
#						icon = "res://assets/images/traits/armor.png", 
#						description = "Damage-absorbing shield (%d remains)",
#						args = [{obj = 'parent_args', param = 0}],
#						t_name = 'ward'
#					}
#				],
#				sub_effects = [],
#			}
#		],
#		buffs = []
#	},
#	e_s_bless_ = {
#		type = 'trigger',
#		trigger = [variables.TR_HIT],
#		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}],
#		req_skill = true,
#		sub_effects = ['e_t_bless'],
#		buffs = []
#	},
#	e_t_bless = {
#		type = 'temp_s',
#		target = 'target',
#		name = 'bless',
#		tick_event = variables.TR_TURN_S,
#		rem_event = variables.TR_COMBAT_F,
#		duration = 4,
#		stack = 1,
#		tags = ['bless'],
#		sub_effects = [],
#		atomic = [
#			{type = 'stat_add', stat = 'damade', value = 10},
##			{type = 'stat_add', stat = 'armor', value = 10},
##			{type = 'stat_add', stat = 'mdef', value = 10},
#			{type = 'stat_add', stat = 'speed', value = 10},
#			{type = 'stat_add', stat = 'hitrate', value = 10},
#			{type = 'stat_add', stat = 'evasion', value = 10},
##			{type = 'stat_add', stat = 'armorpenetration', value = 10}
#		],
#		buffs = [
#			{
#				icon = "res://assets/images/traits/speeddebuf.png", #TO FIX
#				description = "Stats increased",
#				limit = 1,
#				t_name = 'bless'
#			}
#		],
#	},
#	e_s_sanctuary = {
#		type = 'trigger',
#		trigger = [variables.TR_HIT],
#		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}],
#		req_skill = true,
#		args = [{obj = 'self', param = 'skill'}],
#		sub_effects = ['e_t_sanctuary'],
#		buffs = []
#	},
#	e_t_sanctuary = {
#		type = 'temp_s',
#		target = 'target',
#		name = 'sanctuary',
#		tick_event = variables.TR_TURN_F,
#		rem_event = variables.TR_COMBAT_F,
#		duration = 4,
#		stack = 1,
#		tags = ['bless'],
#		args = [{obj = 'parent_arg_get', index = 0, param = 'process_value'}],
#		sub_effects = [
#			{
#				type = 'trigger',
#				trigger = [variables.TR_TURN_GET],
#				conditions = [],
#				req_skill = false,
#				args = [{obj = 'parent_args', param = 0}],
#				sub_effects = [
#					{
#						type = 'oneshot',
#						target = 'owner',
#						args = [{obj = 'parent_args', param = 0}],
#						atomic = ['a_sanctuary_heal'],
#						sub_effects = []
#					}
#				],
#				buffs = []
#			}
#		],
#		atomic = [],
#		buffs = ['b_sanct'],
#	},
	#seems not in use
#	e_s_wave = {
#		type = 'trigger',
#		trigger = [variables.TR_HIT],
#		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}],
#		req_skill = true,
#		sub_effects = ['e_t_wave'],
#		buffs = []
#	},
#	e_t_wave = {
#		type = 'temp_s',
#		target = 'target',
#		name = 'wave',
#		tick_event = variables.TR_TURN_F,
#		rem_event = variables.TR_COMBAT_F,
#		duration = 2,
#		stack = 1,
#		tags = ['natural_debuf'],
#		sub_effects = [
#			{
#				type = 'trigger',
#				trigger = [variables.TR_DEF],
#				conditions = [
##					{type = 'skill', value = ['damagetype','eq',variables.S_AIR] },
#					{type = 'skill', value = ['hit_res','mask',variables.RES_HITCRIT] }
#				],
#				req_skill = true,
#				sub_effects = [
#					{
#						type = 'oneshot',
#						target = 'skill',
#						atomic = [{type = 'stat_mul', stat = 'value', value = 2.0}],
#						sub_effects = []
#					},
#					{
#						type = 'oneshot',
#						target = 'parent',
#						execute = 'remove'
#					}
#				],
#				buffs = []
#			}
#		],
#		atomic = [],
#		buffs = ['b_wave'],
#	},
#	e_s_spiritshield = {
#		type = 'trigger',
#		trigger = [variables.TR_HIT],
#		req_skill = true,
#		conditions = [],
#		sub_effects = [
#			{
#				type = 'temp_s',
#				target = 'target',
#				tick_event = variables.TR_TURN_GET,
#				rem_event = [variables.TR_SHIELD_DOWN, variables.TR_COMBAT_F],
#				duration = 3,
#				stack = 1,
#				name = 'spirit_shield',
#				atomic = [
#					{type = 'shield_add_temporal', shield_id = 'spiritshield', value = 50},
##					{type = 'stat_set_revert', stat = 'shieldtype', value = variables.S_FULL}
#					],
#				args = [{obj = 'app_obj', param = 'shield', dynamic = true}],
#				buffs = [
#					{
#						icon = "res://assets/images/traits/armor.png", 
#						description = "Damage-absorbing shield, blocks 50 damage (%d remains)",
#						args = [{obj = 'parent_args', param = 0}],
#						t_name = 's_shield'
#					}
#				],
#				sub_effects = [],
#			}
#		],
#		buffs = []
#	},
#	e_s_drain_kill = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_KILL],
#		conditions = [],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'caster',
#				atomic = [{type = 'stat_add', stat = 'alt_mana', value = 3}],
#				buffs = [],
#				sub_effects = []
#			}
#		],
#		buffs = []
#	},
#	e_s_drain_crit = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_POSTDAMAGE],
#		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_CRIT]}],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'caster',
#				atomic = [{type = 'stat_add', stat = 'alt_mana', value = 1}],
#				buffs = [],
#				sub_effects = []
#			}
#		],
#		buffs = []
#	},
#	e_cost1 = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_SKILL_FINISH],
#		conditions = [],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'caster',
#				atomic = [{type = 'stat_add', stat = 'alt_mana', value = -1}],
#				buffs = [],
#				sub_effects = []
#			}
#		],
#		buffs = []
#	},
#	e_cost3 = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_SKILL_FINISH],
#		conditions = [],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'caster',
#				atomic = [{type = 'stat_add', stat = 'alt_mana', value = -3}],
#				buffs = [],
#				sub_effects = []
#			}
#		],
#		buffs = []
#	},
#	e_s_implosion = {
#		type = 'trigger',
#		trigger = [variables.TR_HIT],
#		req_skill = true,
#		conditions = [],
#		atomic = [],
#		buffs = [],
#		args = [{obj = 'parent', param = 'target'}],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'skill',
#				args = [{obj = 'parent_arg_get', index = 0, param = 'armor'}],
#				atomic = [{type = 'stat_add', stat = 'value', value = ['parent_args', 0]}],
#				buffs = [],
#				sub_effects = []
#			}
#		]
#	},
#	e_s_explosion_old = {
#		type = 'trigger',
#		trigger = [variables.TR_CAST],
#		req_skill = true,
#		conditions = [],
#		atomic = [],
#		buffs = [],
#		args = [{obj = 'parent', param = 'caster', dynamic = true}],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'skill',
#				args = [{obj = 'parent_arg_get', index = 0, param = 'alt_mana'}],
#				atomic = [{type = 'stat_mul', stat = 'value', value = [['parent_args', 0],'+',1]}],
#				buffs = [],
#				sub_effects = []
#			}
#		]
#	},
#	#weapon
#	e_w_gobmet_h = {
#		type = 'trigger',
#		trigger = [variables.TR_HIT],
#		req_skill = true,
#		conditions = [
#			{type = 'target', value = {type = 'stats', name = 'hppercent', operant = 'lte', value = 25} }
#		],
#		atomic = [],
#		buffs = [],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'skill',
#				atomic = [{type = 'stat_mul', stat = 'value', value = 1.15}],
#				buffs = [],
#				sub_effects = []
#			}
#		]
#	},
#	e_w_elfmet_h = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_HIT],
#		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'caster',
#				atomic = [{type = 'mana', value = 1}],
#				buffs = [],
#				sub_effects = []
#			}
#		],
#		buffs = []
#	},
#	e_w_bone_b = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_HIT],
#		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'caster',
#				atomic = [{type = 'heal', value = 1}],
#				buffs = [],
#				sub_effects = []
#			}
#		],
#		buffs = []
#	},
#	e_w_gobmet_bl = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_POSTDAMAGE],
#		conditions = [
#			{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]},
#			{type = 'skill', value = ['skilltype', 'eq', 'skill']}# need to add this check to most of weapon effects
#		],
#		args = [{obj = 'app_obj', param = 'level', dynamic = true}],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'target',
#				args = [{obj = 'parent_args', param = 0}],
#				atomic = ['a_gobmet_blade'],
#				buffs = [],
#				sub_effects = []
#			}
#		],
#		buffs = []
#	},
#	e_w_elfmet_bl = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_HIT],
#		conditions = [{type = 'target', value = {type = 'stats', name = 'hppercent', operant = 'gte', value = 100} }],
#		atomic = [],
#		buffs = [],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'skill',
#				atomic = [{type = 'stat_add', stat = 'value', value = 10}],
#				buffs = [],
#				sub_effects = []
#			}
#		]
#	},
#	e_w_elfw_r = {
#		type = 'trigger',
#		req_skill = false,
#		trigger = [variables.TR_COMBAT_F],
#		conditions = [],
#		atomic = [],
#		buffs = [],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'owner',
#				args = [{obj = 'app_obj',param = 'manamax'}],
#				atomic = ['a_elvenwood_rod'],
#				buffs = [],
#				sub_effects = []
#			}
#		]
#	},
#	e_w_gobmet_r = {
#		req_skill = true,
#		trigger = [variables.TR_POSTDAMAGE],
#		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}],
#		sub_effects = ['e_taunt'],
#		buffs = ['e_gobmet_rod']
#	},
#	e_gobmet_rod = {
#		type = 'temp_s',
#		target = 'target',
#		tick_event = [variables.TR_TURN_S],
#		rem_event = [variables.TR_COMBAT_F],
#		duration = 1,
#		stack = 1,
#		name = 'gobmet_rod',
#		tags = ['curse'],
#		atomic = [{type = 'stat_add', stat = 'speed', value = -10}],
#		buffs = [ #no icon
##			{
##				icon = load(""), 
##				description = "Speed reduced",
##				limit = 1,
##				t_name = 'gobmet_rod'
##			}
#		]
#	},
#	e_w_bone_r = {
#		type = 'trigger',
#		req_skill = true,
#		trigger = [variables.TR_HIT],
#		conditions = [{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]}],
#		sub_effects = [
#			{
#				type = 'oneshot',
#				target = 'caster',
#				atomic = [{type = 'stat_add', stat = 'hppercent', value = 3}],
#				buffs = [],
#				sub_effects = []
#			}
#		],
#		buffs = []
#	},
#	e_w_dmgtreant = {
#		type = 'trigger',
#		trigger = [variables.TR_HIT],
#		req_skill = true,
#		conditions = [
#			{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]},
#			{type = 'skill', value = ['skilltype', 'eq', 'skill']},
#			{type = 'target', value = {type = 'stats', name = 'base', operant = 'eq', value = 'treant' } }
#		],
#		buffs = [],
#		sub_effects = ['e_autocrit']
#	},
#	e_w_dmgbigtreant = {
#		type = 'trigger',
#		trigger = [variables.TR_HIT],
#		req_skill = true,
#		conditions = [
#			{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]},
#			{type = 'skill', value = ['skilltype', 'eq', 'skill']},
#			{type = 'target', value = {type = 'stats', name = 'base', operant = 'eq', value = 'bigtreant' } }
#		],
#		buffs = [],
#		sub_effects = ['e_autocrit']
#	},
#	e_w_dmggolem = {
#		type = 'trigger',
#		trigger = [variables.TR_HIT],
#		req_skill = true,
#		conditions = [
#			{type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]},
#			{type = 'skill', value = ['skilltype', 'eq', 'skill']},
#			{type = 'target', value = {type = 'stats', name = 'base', operant = 'eq', value = 'earthgolem' } }
#		],
#		buffs = [],
#		sub_effects = ['e_autocrit']
#	},
#	e_w_dmgbiggolem = {
#		type = 'trigger',
#		trigger = [variables.TR_HIT],
#		req_skill = true,
#		conditions = [
#			{target = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]},
#			{target = 'skill', value = ['skilltype', 'eq', 'skill']},
#			{target = 'target', value = {type = 'stats', name = 'base', operant = 'eq', value = 'earthgolemboss' } }
#		],
#		buffs = [],
#		sub_effects = ['e_autocrit']
#	},
#	e_autocrit = {
#		type = 'oneshot',
#		target = 'skill',
#		atomic = [{type = 'stat_set', stat = 'hit_res', value = variables.RES_CRIT}],
#		buffs = [],
#		sub_effects = []
#	},
	#item skills
	#those two barrier effects need fixing cause they for some reason do not work correctly in case of applying to one target 
#	e_i_barrier2 = {
#		type = 'trigger',
#		trigger = [variables.TR_HIT],
#		req_skill = true,
#		conditions = [],
#		sub_effects = [
#			{
#				type = 'temp_s',
#				target = 'target',
#				tick_event = variables.TR_TURN_GET,
#				rem_event = [variables.TR_SHIELD_DOWN,variables.TR_COMBAT_F],
#				duration = 2,
#				stack = 1,
#				name = 'phys_shield',
#				atomic = [
#					{type = 'shield_add_temporal', shield_id = 'barrier2', value = 50},
##					{type = 'stat_set_revert', stat = 'shieldtype', value = variables.S_PHYS}
#					],
#				args = [{obj = 'app_obj', param = 'shield', dynamic = true}],
#				buffs = [
#					{
#						icon = "res://assets/images/traits/armor.png", 
#						description = "Damage-absorbing shield, blocks 50 phys damage (%d remains)",
#						args = [{obj = 'parent_args', param = 0}],
#						t_name = 'icon_barrier2'
#					}
#				],
#				sub_effects = [],
#			}
#		],
#		buffs = []
#	},
#	e_i_barrier3 = {
#		type = 'trigger',
#		trigger = [variables.TR_HIT],
#		req_skill = true,
#		conditions = [],
#		sub_effects = [
#			{
#				type = 'temp_s',
#				target = 'target',
#				tick_event = variables.TR_TURN_GET,
#				rem_event = [variables.TR_SHIELD_DOWN,variables.TR_COMBAT_F],
#				duration = 2,
#				stack = 1,
#				name = 'mag_shield',
#				atomic = [
#					{type = 'shield_add_temporal', shield_id = 'barrier3', value = 50},
##					{type = 'stat_set_revert', stat = 'shieldtype', value = variables.S_MAG}
#					],
#				args = [{obj = 'app_obj', param = 'shield', dynamic = true}],
#				buffs = [
#					{
#						icon = "res://assets/images/traits/armor.png", 
#						description = "Damage-absorbing shield, blocks 50 magic damage (%d remains)",
#						args = [{obj = 'parent_args', param = 0}],
#						t_name = 'icon_barrier3'
#					}
#				],
#				sub_effects = [],
#			}
#		],
#		buffs = []
#	},
#	e_i_barrier2 = {
#		type = 'oneshot',
#		trigger = variables.TR_HIT,
#		conditions = [],
#		effects = [{target = 'target', type = 'temp_effect', effect = 'e_addbarrier2', duration = 2, stack = 1}]
#	},
#	e_i_barrier3 = {
#		type = 'oneshot',
#		trigger = variables.TR_HIT,
#		conditions = [],
#		effects = [{target = 'target', type = 'temp_effect', effect = 'e_addbarrier3', duration = 2, stack = 1}]
#	},
};

var atomic = {
	a_bleed = {type = 'damage', source = 'neutral', value = ['parent_args', 0]},
	a_burn = {type = 'damage', source = 'fire', value = ['parent_args', 0]},
	a_poison = {type = 'damage', source = 'neutral', value = ['parent_args', 0]},
	a_poison_w = {type = 'damage', source = 'water', value = ['parent_args', 0]},
	a_renew_resist = {type = 'stat_add', stat = 'resistdamage', value = ['parent_args', 0]},
	a_souls_clean = {type = 'stat_set', stat = 'alt_mana', value = 0},
	a_souls_add = {type = 'stat_add', stat = 'alt_mana', value = 1},
	#not in use or old
#	a_caster_heal = {type = 'heal', value = [['parent_arg_get', 0, 'process_value'], '*', 0.5]},
#	a_magecrit = {type = 'mana', value = ['parent_arg_get', 0, 'manacost']},
#	a_firefist = {type = 'damage', value = [['parent_arg_get', 0, 'process_value'], '*', 0.2], source = variables.S_FIRE},
#	a_gobmet_blade = {type = 'damage', source = variables.S_EARTH, value = ['parent_args', 0]},
#	a_elvenwood_rod = {type = 'mana', value = [['parent_args', 0], '*', 0.1]},
#	a_stat_add = {type = 'stat_add', stat = ['parent_args', 0], value = ['parent_args', 1]},
#	a_hp_restore_ex = {type = 'heal', value = [['parent_args', 0], '*', 0.2]},#can be made as stat_add to hppercent
#	a_mana_restore_ex = {type = 'mana', value = [['parent_args', 1], '*', 0.2]},
#	a_ward_shield = {type = 'shield_add_temporal', shield_id = 'a_ward_shield', value = ['parent_args', 1]},
#	a_sanctuary_heal = {type = 'heal', value = ['parent_args', 0]},

};
#needs filling
#add bonuseffect = 'duration' to buffs with duration
var buffs = {
	#new part
	b_bleed = { 
		icon = "res://assets/images/iconsskills/arron_3.png", 
		description = "BUFF_BLEED",
		args = [{obj = 'parent_args', param = 1, translate = true}],
		t_name = 'icon_bleed',
		bonuseffect = 'duration'
	},
	b_poison = {
		icon = "res://assets/images/iconsskills/Debilitate.png", 
		description = "BUFF_POISON",
		args = [{obj = 'parent_args', param = 1, translate = true}],
		t_name = 'icon_poison',
		bonuseffect = 'duration'
	},
	b_burn = {
		icon = "res://assets/images/iconsskills/rose_4.png", 
		description = "BUFF_BURN",
		args = [{obj = 'parent_args', param = 1, translate = true}],
		t_name = 'icon_burn',
		bonuseffect = 'duration'
	},
	b_renew1 = {
		icon = "res://assets/images/iconsskills/rose_8.png", 
		description = "BUFF_RENEW_RESIST",
		args = [{obj = 'parent_args', param = 0}],
		t_name = 'icon_renew_resist',
		bonuseffect = 'duration'
	},
	b_gust = {
		icon = "res://assets/images/iconsskills/iola_3.png", 
		description = "BUFF_GUSTOFWIND_DEBUFF",
		args = [{obj = 'parent_args', param = 0}],
		limit = 1,
		t_name = 'icon_gustofwind_debuff',
		bonuseffect = 'duration'
	},
	b_bloodlust = {
		icon = "res://assets/images/iconsskills/tackle.png", 
		description = "BUFF_BLOODLUST",
		args = [{obj = 'parent_args', param = 0}],
		limit = 1,
		t_name = 'icon_bloodlust',
		bonuseffect = 'amount'
	},
	b_enrage = {
		icon = "res://assets/images/iconsskills/taunt.png", 
		description = "BUFF_RAGE",
		args = [{obj = 'parent_args', param = 0}],
		limit = 1,
		t_name = 'icon_rage',
		bonuseffect = 'amount'
	},
	b_barrier = {
		icon = "res://assets/images/traits/armor.png", 
		description = "BUFF_SHIELD_INFO",
		args = [{obj = 'parent_args', param = 1}],
		t_name = 'icon_barrier',
		bonuseffect = 'duration'
	},
	#not in use or old
	#icons are defined by path or by name in images.icons, do not load images here!
#	b_wwalk = { # none
#		icon = "res://assets/images/iconsskills/Debilitate.png", 
#		description = "Stats increased",
#		limit = 1,
#		t_name = 'wwalk'
#	},
#	b_nbless = { # none
#		icon = "res://assets/images/iconsskills/Debilitate.png", 
#		description = "Regenerates HP every turn",
#		limit = 1,
#		t_name = 'nbless'
#	},
#	b_sanct = { # none
#		icon = "res://assets/images/iconsskills/Debilitate.png", 
#		description = "Regenerates HP every turn",
#		limit = 1,
#		t_name = 'sanctuary'
#	},
};

func rebuild_template(args):
	var res = {
		type = 'trigger',
		debug_name = 'starter_rebuilded',
		req_skill = true,
		trigger = [],
		conditions = [],
		buffs = [],
		sub_effects = []
	}
	if args.has('trigger'): res.trigger.push_back(args.trigger) #for simplicity only one trigger type can be passed
	else: res.trigger.push_back(variables.TR_POSTDAMAGE)
	
	if args.has('res_condition'): 
		res.conditions.push_back({type = 'skill', value = ['hit_res', 'mask', args.res_condition]})
	elif res.trigger[0] in [variables.TR_HIT, variables.TR_POSTDAMAGE]: 
		res.conditions.push_back({type = 'skill', value = ['hit_res', 'mask', variables.RES_HITCRIT]})
	
	if args.has('chance'): res.conditions.push_back({type = 'random', value = args.chance})
	
	if args.has('duration'): #for this to work effect should have its duration set to 'parent'
		res.duration = args.duration
	if args.has('push_value'):
		res.args = [{obj = 'parent', param = 'process_value'}]
	
	if args.has('debug_name'):
		res.debug_name = args.debug_name
	
	res.sub_effects.push_back(args.effect)
	
	return res

func rebuild_dot(at_e):
	var res = e_dot_template.duplicate(true)
	res.sub_effects[0].atomic.push_back(at_e)
	return res

func rebuild_dot_onget(at_e):
	var res = e_dot_template.duplicate(true)
	res.trigger = [variables.TR_TURN_GET]
	res.sub_effects[0].atomic.push_back(at_e)
	return res

func rebuild_remove(skill_cond):
	return {
		type = 'trigger',
		trigger = [variables.TR_DEF],
		conditions = [
			{type = 'skill', value = ['hit_res','mask',variables.RES_HITCRIT] },
			{type = 'skill', value = skill_cond.duplicate()}
		],
		req_skill = true,
		sub_effects = [
			{
				type = 'oneshot',
				target = 'parent',
				execute = 'remove'
			}
		],
		buffs = []
	}


func _ready():
	yield(preload_icons(), 'completed')
#	print("Buff icons preloaded")

func preload_icons():
	for b in buffs.values():
		if b.icon.begins_with("res:"): continue
		resources.preload_res(b.icon)
	if resources.is_busy(): yield(resources, "done_work")

func has_damagetype_of_resist(eff, dam_type :String) ->bool:#eff :String/Dictionary
	var effect :Dictionary
	if eff is String:
		assert(effect_table.has(eff), "has_resist_damage_type() tries to get unexistant effect %s" % eff)
		effect = effect_table[eff]
	else:
		effect = eff
	
	if effect.has('atomic'):
		for entry in effect.atomic:
			var atomic_eff :Dictionary
			if entry is String:
				atomic_eff = atomic[entry]
			else:
				atomic_eff = entry
			if atomic_eff.has('type') and atomic_eff.type == 'damage' and atomic_eff.source == dam_type:
				return true
	
	if effect.has('sub_effects'):
		for sub_effect in effect.sub_effects:
			if has_damagetype_of_resist(sub_effect, dam_type):
				return true
	
	return false

func has_status_of_resist(eff, status :String) ->bool:#eff :String/Dictionary
	var effect :Dictionary
	if eff is String:
		assert(effect_table.has(eff), "has_status_of_resist() tries to get unexistant effect %s" % eff)
		effect = effect_table[eff]
	else:
		effect = eff
	
	if effect.has('tags'):
		if effect.tags.has(status):
			return true
	
	if effect.has('sub_effects'):
		for sub_effect in effect.sub_effects:
			if has_status_of_resist(sub_effect, status):
				return true
	
	return false

func get_resists_applicable(eff) ->Array:#eff :String/Dictionary
	var resists = []
	for resist_type in variables.resistlist:#there is idle run for 'damage' resist type, but I leave it for unification purpose
		if has_damagetype_of_resist(eff, resist_type):
			resists.append(resist_type)
	for status in variables.status_list:
		if has_status_of_resist(eff, status):
			resists.append(status)
	return resists



