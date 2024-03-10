extends BaseButton
#this is for buttons with empty button_mask, to avoid native behavior

func _gui_input(event):
	if event.is_action_released("LMB"):
		emit_signal("pressed")
