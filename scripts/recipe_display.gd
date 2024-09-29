extends Node

@onready var image = $Drawing
@onready var text = $Text

var recipe_index: int = 0: set = _set_recipe_index, get = _get_recipe_index
var _recipe_index: int = -1

func _process(_delta: float) -> void:
  if recipe_index == -1:
    recipe_index = 0

func _set_recipe_index(newVal: int) -> void:
  var size = Coffee.instance.recipes.size()
  _recipe_index = ((newVal % size) + size) % size
  var curr_recipe := Coffee.instance.recipes[recipe_index]
  text.text = "[center]%s[/center]\n\n" % curr_recipe.title
  var keys := curr_recipe.ingredients_dict.keys()
  var ing_names := Coffee.Ingredient.keys()
  keys.sort()
  for k in keys:
    text.text += "- %dx %s\n" % [curr_recipe.ingredients_dict[k], ing_names[k]]

  image.texture = curr_recipe.image
  var rect: Rect2 = image.get_rect()
  image.scale = Vector2.ONE * 512 / rect.size.x * 1.145

func _get_recipe_index() -> int:
  return _recipe_index


func _on_next_button_pressed() -> void:
  recipe_index += 1


func _on_prev_button_pressed() -> void:
  recipe_index -= 1
