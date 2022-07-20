extends Panel


func showup(node, character_id, skillcode):
	var character = state.heroes[character_id]
	var skill = Skillsdata.patch_skill(skillcode, character)
	show()
	$name.text = tr("SKILL"+skill.name.to_upper())
#	$cost.text = str(skill.manacost)
#	$cost.visible = skill.manacost != 0
#	$manaicon.visible = skill.manacost != 0
	
#	if skill.skilltype == 'skill':
#		$type.set("custom_colors/font_color", Color(1,0,0))
#	elif skill.skilltype == 'spell':
#		$type.set("custom_colors/font_color", Color(0,0,1))
	$cooldown.text = str(skill.cooldown)
	$type.text = skill.skilltype.capitalize()
#	$descript.bbcode_text = character.skill_tooltip_text(skillcode)
#	$descript.bbcode_text = skill.description
	$descript.bbcode_text = tr("SKILL" + skill.code.to_upper() + "DESCRIPT") #temporal
	#$RichTextLabel.bbcode_text = text
	
	var screen = get_viewport().get_visible_rect()
	if get_rect().end.x >= screen.size.x:
		rect_global_position.x -= get_rect().end.x - screen.size.x
	if get_rect().end.y >= screen.size.y:
		rect_global_position.y -= get_rect().end.y - screen.size.y
	

