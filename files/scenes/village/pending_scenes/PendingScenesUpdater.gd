class_name PendingScenesUpdater extends Node


onready var _scene_unlock_panel = $"../scenes"

var _is_scene_unlock_panel_open = false
var _seen_scenes_pannels = []

func _ready():
	_scene_unlock_panel.connect("hide", self, "update_discovered_pending_scenes")
	_scene_unlock_panel.connect("scene_pannel_drawn", self, "scene_pannel_seen")
	
	state.connect("old_events_accessed", self, "update_pending_scenes")
	state.connect("old_seqs_accessed", self, "update_pending_scenes")

	for character in state.characters:
		var hero_instance: hero = state.heroes[character]
		hero_instance.connect("friend_points_changed", self, "update_pending_scenes")
		hero_instance.connect("lock_status_changed", self, "update_pending_scenes")

func update_discovered_pending_scenes():
	for id in _seen_scenes_pannels:
		state.discovered_pending_scenes.append(id)
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
		
		
		var reqs_fullfilled = state.checkreqs(scene_data.initiate_reqs)
		var has_character = true
		var enough_friend_points = true
		var wasnt_discovered_already = !(scene_id in state.discovered_pending_scenes)
		var is_force_seq_scene = check_is_force_seq_scene(scene_id)
		
		for scene_character in scene_data.unlock_price.keys():
			if !state.heroes[scene_character].unlocked:
				has_character = false
				
			if character_friend_points(scene_character) < scene_data.unlock_price[scene_character]:
				enough_friend_points = false
		
		if reqs_fullfilled && enough_friend_points && wasnt_discovered_already  && !is_force_seq_scene && has_character:
			scenes.append(scene_id)

	state.update_pending_scenes(scenes)

func character_friend_points(character: String) -> int:
	return state.heroes[character].friend_points

func check_is_force_seq_scene(scene_name: String) -> bool:
	for trigger in Explorationdata.event_triggers:
		for event in Explorationdata.event_triggers[trigger]:
			if event["type"] == "force_seq_seen" && event["value"] == scene_name:
				return true
			
	return false
