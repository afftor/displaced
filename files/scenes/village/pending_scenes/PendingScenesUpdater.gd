#class_name PendingScenesUpdater
extends Node


onready var _scene_unlock_panel = get_parent()

var _is_scene_unlock_panel_open = false
var _seen_scenes_pannels = []

func _ready():
	#MIND that such simplified conditions works only while gallery is all nude!
	#So no pending update done, if no connection made
	#change this, if adding here something extra, not about connections
	if globals.is_boring_type(): return
	
	_scene_unlock_panel.connect("hide", self, "update_discovered_pending_scenes")
	_scene_unlock_panel.connect("scene_pannel_drawn", self, "scene_pannel_seen")
	
	state.connect("old_events_updated", self, "update_pending_scenes")
	state.connect("old_seqs_updated", self, "update_pending_scenes")
	globals.connect("scene_changed", self, "update_pending_scenes")

	for character in state.characters:
		var hero_instance: hero = state.heroes[character]
		hero_instance.connect("friend_points_changed", self, "update_pending_scenes")
		hero_instance.connect("lock_status_changed", self, "update_pending_scenes")

func update_discovered_pending_scenes():
	if _seen_scenes_pannels.empty(): return
	
	state.discovered_pending_scenes.append_array(_seen_scenes_pannels)
	_seen_scenes_pannels = []
	update_pending_scenes()

func scene_pannel_seen(id: String):
	if id in state.pending_scenes && !(id in state.discovered_pending_scenes):
		_seen_scenes_pannels.append(id)


func update_pending_scenes():
	var scenes = []

	for scene_id in Explorationdata.scene_sequences:
		var scene_data = Explorationdata.scene_sequences[scene_id]
		if !scene_data.has("gallery"): continue
		if scene_data.has('permit_reqs') and !state.checkreqs(scene_data.permit_reqs): continue
		
		var reqs_fullfilled = state.checkreqs(scene_data.initiate_reqs)
		
		var was_discovered_already = scene_id in state.discovered_pending_scenes
		var is_unlocked = state.OldSeqs.has(scene_id)
		
		var has_character = true
		var enough_friend_points = true
		for scene_character in scene_data.unlock_price.keys():
			if !state.heroes[scene_character].unlocked:
				has_character = false
			if character_friend_points(scene_character) < scene_data.unlock_price[scene_character]:
				enough_friend_points = false
		
		if was_discovered_already and (is_unlocked or !enough_friend_points):
			state.discovered_pending_scenes.erase(scene_id)
			was_discovered_already = false#not really relevant, as at such conditions scene will not pend
		
		if !is_unlocked && !was_discovered_already && reqs_fullfilled && enough_friend_points && has_character:
			scenes.append(scene_id)

	state.update_pending_scenes(scenes)

func character_friend_points(character: String) -> int:
	return state.heroes[character].friend_points

#func check_is_force_seq_scene(scene_name: String) -> bool:
#	var scene_data = Explorationdata.scene_sequences[scene_name]
#	return (scene_data.has("auto_unlocked") and scene_data.auto_unlocked)
