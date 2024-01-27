extends Popup
#confirmpanel can be used also for notification (no "confirm" needed)
#this is done for unification purpose

var targetnode
var targetfunction

onready var confirm_btn = $buttons/Confirm
onready var cancel_btn = $buttons/Cancel

func _ready():
#warning-ignore:return_value_discarded
	confirm_btn.connect('pressed',self, 'ConfirmPanelConfirm')
#warning-ignore:return_value_discarded
	cancel_btn.connect('pressed', self, 'CloseConfirmPanel')

func show_confirm(TargetNode, ConfirmFunction, Text, Confirm = '', Cancel = ''):
	popup()
	$RichTextLabel.bbcode_text = Text
	targetnode = TargetNode
	targetfunction = ConfirmFunction
	confirm_btn.show()
	if !Confirm.empty():
		confirm_btn.get_node("Label").text = Confirm
	if !Cancel.empty():
		cancel_btn.get_node("Label").text = Cancel
	else:
		cancel_btn.get_node("Label").text = tr("CANCEL")

func show_notify(Text, Cancel = ''):
	popup()
	$RichTextLabel.bbcode_text = Text
	confirm_btn.hide()
	if !Cancel.empty():
		cancel_btn.get_node("Label").text = Cancel
	else:
		cancel_btn.get_node("Label").text = tr("CLOSE")

func ConfirmPanelConfirm():
	hide()
	targetnode.call(targetfunction)


func CloseConfirmPanel():
	hide()

