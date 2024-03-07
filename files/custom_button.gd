extends BaseButton
#this is for buttons with empty button_mask

func _gui_input(event):
	if event.is_action_released("LMB"):
		emit_signal("pressed")
