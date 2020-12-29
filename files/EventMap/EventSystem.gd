extends Node

signal state_update(cstate)

const EV_PATH = "res://assets/data/txt_ref/evmap.txt"
const KEYWORDS = [
	"bat", "none",
	"scn", "sel",
	"char", "req",
	"dec", "buy",
	"regular"
]
const ACWORDS = [
	"bat", "scn",
	"sel", "char"
]

const INSTACWORDS = [
	"sel", "char"
]

const DIR_BASE = {
	"trigger_type" : "",
	"trigger_arg" : PoolStringArray(),
	"actions" : [],
	"reqs" : [],
	"flags" : {
		"regular" : false
	},
	"id" : -1
}

var gets = {}
var cstate = []
var action_log = []
var inprog_log = []
var current_updates = []
var bought = []
var sels = []
var decisions = []

var ev_src = ""
var events_map = []

var wallet = 0

func _ready() -> void:
	var f = File.new()
	f.open(EV_PATH, File.READ)
	ev_src = f.get_as_text().split("\n")
	f.close()
	events_map = build_events_map(ev_src)
	yield(get_tree(), "idle_frame")
	make_a_step()


func ac_to_gets(type: String, nameof: String, putlog = true) -> void:
	
	if type == "buy":
		var splitted = nameof.split("|")
		print(splitted)
		wallet -= int(splitted[0])
		bought.append(int(splitted[2]))
		return
	
	if type == "sel" && !nameof in sels:
		sels.append(nameof)
	
	if putlog: action_log.append([type, nameof])
	if gets.keys().has(type):
		if !nameof in gets[type]:
			gets[type].append(nameof)
	else:
		gets[type] = [nameof]


func update_state(ev: Dictionary) -> void:
	var last_type = ""
	var allpassed = true
	if ev["trigger_type"] == "buy" && ! ev["id"] in bought:
		cstate.append(["buy", ev["trigger_arg"] + "|" + \
					str(ev["actions"]) + "|" + str(ev["id"])])
		return
	if ! ev["id"] in inprog_log:
		inprog_log.append(ev["id"])
	
	for i in ev["actions"]:
		var a = i.split(" ")
		if a.size() == 1 && last_type != "" && last_type in ACWORDS:
			if gets.keys().has(last_type) && a[0] in gets[last_type]:
				continue
			if last_type in INSTACWORDS:
				ac_to_gets(last_type, a[0], false)
			else:
				cstate.append([last_type, a[0]])
				allpassed = false
				break
		elif a.size() == 2 && a[0] in ACWORDS:
			last_type = a[0]
			if gets.keys().has(a[0]) && a[1] in gets[a[0]]:
				continue
			if a[0] in INSTACWORDS:
				ac_to_gets(a[0], a[1], false)
			else:
				cstate.append(a)
				allpassed = false
				break
		else:
			print("Cannot understand action: ", i)
	if allpassed:
		if ev["flags"]["regular"]:
			last_type = ""
			for i in ev["actions"]:
				var a = i.split(" ")
				if a.size() == 1 && last_type != "" && last_type in ACWORDS:
					if gets.keys().has(last_type) && a[0] in gets[last_type]:
						gets[last_type].erase(a[0])
				elif a.size() == 2 && a[0] in ACWORDS:
					last_type = a[0]
					if gets.keys().has(a[0]) && a[1] in gets[a[0]]:
						gets[a[0]].erase(a[1])
				else:
					print("Cannot understand action: ", i)
		if ev["id"] in inprog_log:
			inprog_log.erase(ev["id"])
		cstate.append(["upd"])



func make_a_step() -> void:
	cstate = []
	current_updates = []
	var last_action = []
	if action_log.size() > 0:
		last_action = action_log[action_log.size() - 1]
	for i in events_map:
		var last_type = ""
		var reqmet = true
		for j in i["reqs"]:
			var creq = j.split(" ")
			if creq.size() == 1 && last_type != "":
				if !(gets.keys().has(last_type) && creq[0] in gets[last_type]):
					reqmet = false
					break
			elif creq.size() == 2:
				last_type = creq[0]
				if !(gets.keys().has(creq[0]) && creq[1] in gets[creq[0]]):
					reqmet = false
					break
			else:
				print("Cannot understand req: ", creq)
				reqmet = false
				break
		if !reqmet:
			continue
		
		var doupdate = false
		if last_action.size() == 2:
			if i["trigger_type"] == last_action[0] && \
				i["trigger_arg"] == last_action[1]:
					doupdate = true
		if !doupdate:
			for j in inprog_log:
				if j == i["id"]:
						doupdate = true
		if !doupdate && i["trigger_type"] == "none" || \
			(i["trigger_type"] == "dec" && i["trigger_arg"] in decisions) || \
			(i["trigger_type"] == "buy" && \
			((!i["id"] in bought && wallet >= int(i["trigger_arg"])) || \
			(  i["id"] in bought))):
			doupdate = true
		if doupdate: current_updates.append(i)
	
	var to_ignore = []
	
	for i in current_updates:
		var last_type = ""
		var allpassed = true
		for ac in i["actions"]:
			var a = ac.split(" ")
			if a.size() == 1 && last_type != "" && last_type in ACWORDS:
				if !(gets.keys().has(last_type) && a[0] in gets[last_type]):
					allpassed = false
					break
			elif a.size() == 2 && a[0] in ACWORDS:
				last_type = a[0]
				if !(gets.keys().has(a[0]) && a[1] in gets[a[0]]):
					allpassed = false
					break
			else:
				print("Cannot understand action: ", i)
		
		if allpassed:
			if !i["flags"]["regular"]:
				to_ignore.append(i)
	
	for i in to_ignore:
		current_updates.erase(i)
	
	to_ignore = []
	
	for i in current_updates:
		if i["flags"]["regular"]:
			to_ignore.append(i)
	
	for i in to_ignore:
		current_updates.erase(i)
		current_updates.append(i)
	
	for i in current_updates:
		for j in current_updates:
			if i == j: continue
			if i["trigger_type"] != j["trigger_type"] || \
				i["trigger_arg"] != j["trigger_arg"]: continue
			current_updates.erase(j)
	
	for i in current_updates: update_state(i)
	
	var addtomap = true
	for i in sels:
		if i.begins_with("unlock"):
			for j in sels:
				if j.begins_with("lock_"):
					sels.erase(j)
					sels.append(j.replace("lock_", ""))
			sels.erase(i)
			break
	for i in sels:
		if i.begins_with("lock_"):
			cstate.append(["sel", i.replace("lock_", "")])
			addtomap = false
			break
	for i in sels:
		if i.begins_with("rm_"):
			if i.replace("rm_", "") in sels:
				sels.erase(i.replace("rm_", ""))
			sels.erase(i)
	if addtomap:
		for i in sels:
			cstate.append(["sel", i])
	cstate.append(["wallet", wallet])
	emit_signal("state_update", cstate)
	if cstate.has(["upd"]):
		yield(get_tree(), "idle_frame")
		make_a_step()


func parse_dir(directive: Dictionary, splitted: Array) -> void:
	var trigger_part = splitted[0].split(" ")
	directive["trigger_type"] = trigger_part[0]
	trigger_part.remove(0)
	directive["trigger_arg"] = trigger_part.join(" ")
	directive["actions"] = splitted[1].split(", ")


func parse_req(directive: Dictionary, txt: String) -> void:
	var splitted = txt.strip_edges().split(" ")
	if splitted.size() == 1:
		if splitted[0] in KEYWORDS:
			match splitted[0]:
				"regular" : directive["flags"][splitted[0]] = true
	else:
		if splitted[0] == "req":
			splitted.remove(0)
			directive["reqs"] = splitted.join(" ").split(", ")


func build_events_map(lines: PoolStringArray) -> Array:
	var out = []
	var c = 0
	var directive = DIR_BASE.duplicate(true)

	for i in lines:
		if i.begins_with("#"):
			c += 1
			continue

		var spl = i.split("->")
		if spl.size() == 2:
			for j in range(spl.size()):
				spl[j] = spl[j].strip_edges()
			parse_dir(directive, spl)
			directive["id"] = c
			out.append(directive)
			directive = DIR_BASE.duplicate(true)
		else:
			parse_req(directive, i)

		c += 1

	return out
