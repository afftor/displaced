extends Control#SpineSprite should be child

export var anim = ""

func _ready():
	var spine_sprite = get_child(0)
	if anim.empty():
		anim = spine_sprite.get_skeleton().get_data().get_animations()[0].get_name()
	spine_sprite.get_animation_state().set_animation(anim, true, 0)

#nothing of this is working in our case
#	var skin = get_skeleton().get_data().find_skin("default")
#	var custom_skin = new_skin("test")
#	custom_skin.add_skin(skin)
##	var att_name
#	custom_skin.remove_attachment(3, "Arron_body")
#	for i in custom_skin.get_attachments():
#		print("%s %s" % [i.get_slot_index(), i.get_name()])
#	for i in skin.get_attachments():
#		if i.get_slot_index() == 9:
#			print("есть!")
##			att_name = i.get_attachment().get_attachment_name()
#			att_name = i.get_name()
#	for i in skin.find_attachments_for_slot(2):
#	for i in skin.find_names_for_slot(17):
#		print("есть")
#		att_name = i
#	get_skeleton().set_skin(custom_skin)
#	get_skeleton().set_slots_to_setup_pose()
#	for i in get_skeleton().get_data().get_skins():
#		print(i.get_name())
#	for i in get_skeleton().get_data().get_slots():
#		print(i.get_index())
