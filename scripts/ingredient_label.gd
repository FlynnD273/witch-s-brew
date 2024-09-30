extends Label

@export var offset := Vector2(10, 10)

@onready var viewport := get_viewport()

var ingredient: Coffee.Ingredient: set = _set_ingredient, get = _get_ingredient
var _ingredient: Coffee.Ingredient

func _ready() -> void:
  hide()

func _process(_delta: float) -> void:
  position = viewport.get_mouse_position() + offset


func _set_ingredient(newValue: Coffee.Ingredient) -> void:
  _ingredient = newValue
  text = Coffee.Ingredient.keys()[ingredient]

func _get_ingredient() -> Coffee.Ingredient:
  return _ingredient
