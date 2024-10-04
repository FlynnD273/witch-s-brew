extends Control

@export var trans_duration: float = 2
@export var pause_duration: float = 1

func _ready() -> void:
  hide()

func transition(text: String) -> void:
  $Label.text = text
  modulate = Color(1, 1, 1, 0)
  show()
  var tween := create_tween()
  tween.tween_property(self, "modulate", Color.WHITE, trans_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
  await get_tree().create_timer(trans_duration + pause_duration).timeout
  tween = create_tween()
  tween.tween_property(self, "modulate", Color(1, 1, 1, 0), trans_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
  tween.tween_callback(func (): hide())
  await get_tree().create_timer(trans_duration).timeout
