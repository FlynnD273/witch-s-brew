extends Label

@export var offset := Vector2(10, 10)

@onready var viewport := get_viewport()

var ingredient: IngredientController: set = _set_ingredient, get = _get_ingredient
var _ingredient: IngredientController

func _ready() -> void:
  hide()

func _process(_delta: float) -> void:
  position = viewport.get_mouse_position() + offset


func _set_ingredient(newValue: IngredientController) -> void:
  _ingredient = newValue
  var ing_name: String = Coffee.Ingredient.keys()[ingredient.type].capitalize()
  text = ing_name
  size = theme.get_font("", "").get_string_size(text)

func _get_ingredient() -> IngredientController:
  return _ingredient
