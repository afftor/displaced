extends Node

var targetnode
var targetfunction

func _ready():
	$Confirm.connect('pressed',self, 'ConfirmPanelConfirm')
	$Cancel.connect('pressed', self, 'CloseConfirmPanel')

func Show(TargetNode, ConfirmFunction, Text):
	popup()
	$RichTextLabel.bbcode_text = Text
	targetnode = TargetNode
	targetfunction = ConfirmFunction

func ConfirmPanelConfirm():
	hide()
	targetnode.call(targetfunction)


func CloseConfirmPanel():
	hide()

