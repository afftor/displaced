extends Control

func _ready():
	$Button.connect("pressed", self, "hide")

func show_credits() -> void:
	$Text.bbcode_text = tr("CREDITS_TEXT")
	show()

func show_end_credits() -> void:
	$Button.disconnect("pressed", self, "hide")
	$Button.connect("pressed", self, "end_hide")
	show_credits()

func end_hide() -> void:
	globals.CurrentScene.queue_free()
	globals.ChangeScene('menu')
	queue_free()
