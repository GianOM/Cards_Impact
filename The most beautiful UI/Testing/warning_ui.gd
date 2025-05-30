extends Panel

@onready var warning_label: RichTextLabel = %WarningLabel

var tween: Tween
@warning_ignore("shadowed_variable_base_class")
var is_visible := false

func _ready() -> void:
	SignalManager.warning_message.connect(show_warning)
	modulate = Color.TRANSPARENT
	hide()

func show_warning(msg: String) -> void:
	is_visible = true
	if tween:
		tween.kill()
	
	warning_label.text = msg
	#print(msg)
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(show)
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
	get_tree().create_timer(1).timeout.connect(hide_warning)
	

func hide_warning() -> void:
	is_visible = false
	if tween:
		tween.kill()
	
	get_tree().create_timer(0.2, false).timeout.connect(hide_animation)

func hide_animation() -> void:
	if not is_visible:
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
		tween.tween_callback(hide)
