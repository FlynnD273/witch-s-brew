extends TextureButton

@export var type: Coffee.Ingredient = Coffee.Ingredient.A
@export var liquid: PackedScene = null
var start_size: float
var hover_scale: float = 1.25
var was_paused: bool = false
var is_focused: = false: set = _set_focused, get = _get_focused
var _is_focused: = false
var is_clicked: = false: set = _set_pressed, get = _get_pressed
var _is_clicked: = false
@onready var tree := get_tree()

func _ready() -> void:
  button_down.connect(_button_down)
  button_up.connect(_button_up)
  mouse_entered.connect(_mouse_entered)
  mouse_exited.connect(_mouse_exited)
  start_size = size.x
  custom_minimum_size.y = start_size*hover_scale

func _process(_delta: float) -> void:
  if was_paused and !tree.paused:
    is_focused = is_focused
    is_clicked = is_clicked
  was_paused = tree.paused

func _button_down() -> void:
  if !tree.paused:
    is_clicked = true

func _button_up() -> void:
  if is_clicked and is_focused and !tree.paused:
    Coffee.instance.add_ingredient(type, liquid)
  is_clicked = false

func _set_pressed(newValue: bool) -> void:
  _is_clicked = newValue
  if tree.paused:
    return
  if is_clicked:
    var tween := create_tween()
    tween.tween_property(self, "modulate", Color(0.8, 0.8, 0.8), 0.1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
  else:
    var tween := create_tween()
    tween.tween_property(self, "modulate", Color.WHITE, 0.1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)

func _get_pressed() -> bool:
  return _is_clicked

func _set_focused(newValue: bool) -> void:
  _is_focused = newValue
  if tree.paused:
    return
  if is_focused:
    var tween := create_tween()
    tween.tween_property(self, "custom_minimum_size", Vector2(start_size * hover_scale, size.y), 0.25).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
    Coffee.instance.ingredient_label.ingredient = type
    Coffee.instance.ingredient_label.show()
  else:
    var tween := create_tween()
    tween.tween_property(self, "custom_minimum_size", Vector2(start_size, size.y), 0.25).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
    if Coffee.instance.ingredient_label.ingredient == type:
      Coffee.instance.ingredient_label.hide()

func _get_focused() -> bool:
  return _is_focused


func _mouse_entered() -> void:
  is_focused = true

func _mouse_exited() -> void:
  is_focused = false
