extends TextureButton

func _ready() -> void:
  button_down.connect(_button_down)
  button_up.connect(_button_up)

func _button_down() -> void:
  var tween := create_tween()
  tween.tween_property(self, "modulate", Color(0.8, 0.8, 0.8), 0.1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)

func _button_up() -> void:
  var tween := create_tween()
  tween.tween_property(self, "modulate", Color.WHITE, 0.1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
