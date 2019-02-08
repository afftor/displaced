extends Node

onready var TextField = $Panel/DisplayText
onready var ImageSprite = $CharImage
onready var ChoiceContainer = $ChoicePanel/VBoxContainer

var text_log = ''

var CurrentScene
var CurrentLine = 0

var ShownCharacters = 0.0

var enableskip = false

var EndOfDialogue = false
var Delay = 0
var ReceiveInput = false


# var SceneData = load("res://files/DialoguesData.gd").new()


var choicedict = {
	choiceexample = [{text = 'Choice 1', function = 'Close', reqs = null}]
}

func _process(delta):
	if TextField.get_total_character_count() > TextField.visible_characters:
		if globals.globalsettings.textspeed >= 240:
			ShownCharacters = TextField.get_total_character_count()
		else:
			ShownCharacters += delta*globals.globalsettings.textspeed
		TextField.visible_characters = ShownCharacters
	if Delay > 0:
		Delay -= delta
		if Delay < 0:
			Delay = 0
	if ((ReceiveInput == false && Delay == 0) || enableskip == true):
		AdvanceScene()

func _input(event):
	
	if event.is_action("ctrl"):
		if event.is_pressed():
			enableskip = true
		else:
			enableskip = false
	if event.is_echo() == true || event.is_pressed() == false || !ReceiveInput || $MenuPanel.visible :
		return
	
	if $LogPanel.visible == true:
		if event.is_action("MouseDown") && ($LogPanel/RichTextLabel.get_v_scroll().value + $LogPanel/RichTextLabel.get_v_scroll().page == $LogPanel/RichTextLabel.get_v_scroll().max_value || !$LogPanel/RichTextLabel.get_v_scroll().visible):
			$LogPanel.hide()
		return
	
	
	if (event.is_action("LMB") || event.is_action("MouseDown")) && event.is_pressed() && $Panel.visible:
		if $Panel/Log.get_global_rect().has_point(get_global_mouse_position()) || $Panel/Options.get_global_rect().has_point(get_global_mouse_position()):
			return
		if TextField.get_visible_characters() < TextField.get_total_character_count():
			TextField.set_visible_characters(TextField.get_total_character_count())
		else:
			if EndOfDialogue != true && CurrentScene != null:
				ReceiveInput = false
				AdvanceScene()
	if event.is_action("RMB") && event.is_pressed():
		$Panel.visible = !$Panel.visible
	if event.is_action("MouseUp"):
		OpenLog()
	

func _ready():
	globals.AddPanelOpenCloseAnimation($LogPanel)
	$Panel/Log.connect("pressed",self,'OpenLog')
	$Panel/Options.connect('pressed', self, 'OpenOptions')
	#CurrentScene = SceneData.introdesert
	add_to_group('pauseprocess');


func OpenLog():
	$LogPanel/RichTextLabel.bbcode_text = text_log
	$LogPanel.show()
	yield(get_tree().create_timer(0.2), 'timeout')
	$LogPanel/RichTextLabel.scroll_to_line($LogPanel/RichTextLabel.get_line_count()-1)

func OpenOptions():
	$MenuPanel.show()

func Start(dict, line = 0):
	if dict == null: 
		call_deferred('StopEvent');
		return;

	$Background.texture = null
	$CharImage.texture = null
	$Panel/CharPortrait.texture = null
	$Panel/DisplayText.bbcode_text = ''
	$Panel/DisplayName/Label.text = ''
	$Panel/DisplayName.visible = false
	$Panel/CharPortrait.visible = false
	$Panel.visible = false
	$CharImage.modulate = Color(1, 1, 1, 0);
	#$bl.modulate = Color(1, 1, 1, 1);
	$BlackScreen.modulate.a = 0;
	CurrentScene = dict
	if line > 0:
		RestoreEnv(line);
	CurrentLine = line;
	set_process(true);
	set_process_input(true);
	AdvanceScene()

func RestoreEnv(line):
	var tmp;
	tmp = line - 1;
	while tmp >= 0:
		if CurrentScene[tmp].effect == 'gui':
			$Panel.visible = !$Panel.visible;
			break;
			pass
		tmp -= 1;
		pass
	tmp = line - 1;
	while tmp >= 0:
		if CurrentScene[tmp].effect == 'background':
			input_handler.SmoothTextureChange($Background, images.backgrounds[CurrentScene[tmp].value]);
			break;
			pass
		tmp -= 1;
		pass
	tmp = line - 1;
	while tmp >= 0:
		if CurrentScene[tmp].effect == 'music':
			input_handler.SetMusic(CurrentScene[tmp].value);
			break;
			pass
		tmp -= 1;
		pass
	tmp = line - 1;
	while tmp >= 0:
		if CurrentScene[tmp].effect == 'sprite':
			if CurrentScene[tmp].value == 'hide':
				break
			if CurrentScene[tmp].value == 'set':
				SpriteDo($CharImage, 'set', CurrentScene[tmp].args);
				break
			if CurrentScene[tmp].value == 'fade':
				$CharImage.modulate = Color(1, 1, 1, 0);
			pass
		tmp -= 1;
		pass
		tmp = line - 1;
	while tmp >= 0:
		if CurrentScene[tmp].effect == 'sfx':
			if CurrentScene[tmp].value == 'blackscreenturnon' or CurrentScene[tmp].value == 'blackscreenunfade':
				blackscreenturnon();
				break
			pass
		tmp -= 1;
		pass
	pass

func AdvanceScene():
	if CurrentScene.size() > CurrentLine:
		var NewEffect = CurrentScene[CurrentLine]
		match NewEffect.effect:
			'gui': #надо пофиксить некорректное скрытие-раскрытие 
				GuiDo(NewEffect.value);
			'background':
				input_handler.SmoothTextureChange($Background, images.backgrounds[NewEffect.value])
			'music':
				input_handler.SetMusic(NewEffect.value)
			'sfx':
				self.call(NewEffect.value, NewEffect.args)
			'text':
				ShownCharacters = 0
				if NewEffect.source != 'narrator':
					text_log += '\n\n' + '[' + tr(NewEffect.source) + ']\n' + tr(NewEffect.value)
				else:
					text_log += '\n\n' + tr(NewEffect.value)
				TextField.visible_characters = ShownCharacters
				TextField.bbcode_text = tr(NewEffect.value)
				$Panel/DisplayName.visible = NewEffect.source != 'narrator'
				$Panel/CharPortrait.visible = NewEffect.source != 'narrator'
				$Panel/DisplayName/Label.text = tr(NewEffect.source)
				if $Panel/CharPortrait.visible:
					if NewEffect.portrait == null || images.portraits.has(NewEffect.portrait) == false:
						$Panel/CharPortrait.texture = null
					else:
						$Panel/CharPortrait.texture = images.portraits[NewEffect.portrait]
				ReceiveInput = true
			'sprite':
				SpriteDo(ImageSprite, NewEffect.value, NewEffect.args)
			'nextevent':
				Start(NewEffect.value)
			'stop':
				StopEvent()
		if NewEffect.has('delay'):
			Delay = NewEffect.delay
		
		CurrentLine += 1

func SpriteDo(node, value, args):
	match value:
		'set':
			node.texture = images.sprites[args]
		'unfade':
			input_handler.UnfadeAnimation(node, args)
		'fade':
			input_handler.FadeAnimation(node, args)
		'hide':
			node.texture = null

func Choice(array):
	for i in ChoiceContainer.get_children():
		if i.name != 'Button':
			i.queue_free()
	
	$ChoicePanel.visible = true
	
	for dictionary in array:
		if dictionary.reqs != null:
			continue
		var newbutton = ChoiceContainer.get_node("Button").duplicate()
		ChoiceContainer.add_child(newbutton)
		newbutton.show()
		newbutton.text = dictionary.text
		newbutton.connect("pressed", self, dictionary.function)

func StopEvent():
	set_process(false)
	set_process_input(false)
	state.FinishEvent();
	globals.CurrentScene.show()
	hide()
	globals.call_deferred('EventCheck');

func blackscreentransition(duration = 0.5):
	input_handler.UnfadeAnimation($BlackScreen, duration)
	input_handler.emit_signal("ScreenChanged")
	input_handler.FadeAnimation($BlackScreen, duration, duration)

func blackscreenturnon(args = null):
	$BlackScreen.visible = true
	$BlackScreen.modulate.a = 1

func blackscreenfade(duration = 0.5):
	input_handler.emit_signal("ScreenChanged")
	input_handler.FadeAnimation($BlackScreen, duration)

func blackscreenunfade(duration = 0.5):
	input_handler.emit_signal("ScreenChanged")
	input_handler.UnfadeAnimation($BlackScreen, duration)

func shakeanim(duration = 0.2):
	input_handler.emit_signal("ScreenChanged")
	input_handler.ShakeAnimation(self, duration)

func shakespr(duration = 0.2):
	input_handler.emit_signal("ScreenChanged")
	input_handler.ShakeAnimation(ImageSprite, duration)

func GuiDo(value):
	match value:
		'showgui':
			$Panel/DisplayName.visible = false
			$Panel/CharPortrait.visible = false
			$Panel.visible = true
		'hidegui':
			$Panel.visible = false

