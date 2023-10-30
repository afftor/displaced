extends NinePatchRect


func showup(node, character_id, skillcode):
	var character = state.heroes[character_id]
	var skill = Skillsdata.patch_skill(skillcode, character)
	show()
	$name.text = tr(skill.name)
#	$cost.text = str(skill.manacost)
#	$cost.visible = skill.manacost != 0
#	$manaicon.visible = skill.manacost != 0
	
#	if skill.skilltype == 'skill':
#		$type.set("custom_colors/font_color", Color(1,0,0))
#	elif skill.skilltype == 'spell':
#		$type.set("custom_colors/font_color", Color(0,0,1))
	$cooldown.text = "%s %s" % [str(skill.cooldown), tr("SKILLTURNS")]
#	$type.text = skill.skilltype.capitalize()#put back, when needed!!!
#	$descript.bbcode_text = character.skill_tooltip_text(skillcode)
#	$descript.bbcode_text = skill.description
	$descript.bbcode_text = tr(skill.description) #temporal
	#$RichTextLabel.bbcode_text = text
	
	var damage_type :String = Skillsdata.get_true_damagetype(skill.damagetype, character_id)
	var damage_type_node = $damagetype
	if damage_type.empty():
		damage_type_node.hide()
	else:
		damage_type_node.show()
		damage_type_node.set_resist_type(damage_type)
	
	var screen = get_viewport().get_visible_rect()
	if get_rect().end.x >= screen.size.x:
		rect_global_position.x -= get_rect().end.x - screen.size.x
	if get_rect().end.y >= screen.size.y:
		rect_global_position.y -= get_rect().end.y - screen.size.y
	





