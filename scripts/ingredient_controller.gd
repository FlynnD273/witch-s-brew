extends TextureButton

@export var type: Coffee.Ingredient = Coffee.Ingredient.A
@export var liquid: PackedScene = null
var start_size: float
var hover_scale: float = 1.25
var on_button: bool = false

func _ready() -> void:
  button_down.connect(_button_down)
  button_up.connect(_button_up)
  mouse_entered.connect(_mouse_entered)
  mouse_exited.connect(_mouse_exited)
  start_size = size.x
  custom_minimum_size.y = start_size*hover_scale

func _button_down() -> void:
  var tween := create_tween()
  tween.tween_property(self, "modulate", Color(0.8, 0.8, 0.8), 0.1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)

func _button_up() -> void:
  var tween := create_tween()
  tween.tween_property(self, "modulate", Color.WHITE, 0.1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)

  if on_button:
    Coffee.instance.add_ingredient(type, liquid)

func _mouse_entered() -> void:
  var tween := create_tween()
  custom_minimum_size = Vector2.ONE * start_size
  tween.tween_property(self, "custom_minimum_size", Vector2(start_size * hover_scale, size.y), 0.25).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
  on_button = true

func _mouse_exited() -> void:
  var tween := create_tween()
  tween.tween_property(self, "custom_minimum_size", Vector2(start_size, size.y), 0.25).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
  on_button = false
