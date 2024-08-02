extends NinePatchRect

export(float) var desc_bottom_margin
onready var desc_node = $descript
var cur_skill :String = ""

func _ready():
	desc_node.connect("item_rect_changed", self, "on_desc_rect_changed")

func on_desc_rect_changed() ->void:
	rect_size.y = desc_node.get_rect().end.y + desc_bottom_margin

func prepare(character_id, skillcode):
	cur_skill = skillcode
	var character = state.heroes[character_id]
	var skill = Skillsdata.patch_skill(skillcode, character)
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
#	$descript.bbcode_text = character.skill_tooltip_text(skillcode)#seems to be too old
	desc_node.bbcode_text = Skillsdata.get_description(skill)
	#$RichTextLabel.bbcode_text = text
	
	var damage_type :String = Skillsdata.get_true_damagetype(skill.damagetype, character_id)
	var damage_type_node = $damagetype
	if damage_type.empty():
		damage_type_node.hide()
	else:
		damage_type_node.show()
		damage_type_node.set_resist_type(damage_type)
	
	#mind, that this probably usless, as we position tooltip after prepare()
	var screen = get_viewport().get_visible_rect()
	if get_rect().end.x >= screen.size.x:
		rect_global_position.x -= get_rect().end.x - screen.size.x
	if get_rect().end.y >= screen.size.y:
		rect_global_position.y -= get_rect().end.y - screen.size.y
	

func get_estimated_height() ->float:
	var text_height = desc_node.get_content_height()
	if text_height < desc_node.rect_min_size.y:
		text_height = desc_node.rect_min_size.y
	return desc_node.rect_position.y + text_height + desc_bottom_margin

func get_skillcode() -> String:
	return cur_skill

