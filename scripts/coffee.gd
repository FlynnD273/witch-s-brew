extends Control

class_name Coffee

static var instance: Coffee = null

var default_theme: Theme = preload("res://default_theme.tres")

signal on_reset
signal on_serve

enum Ingredient {
  A,
  B,
  C,
  D,
}

var current_ingredients: Array[Ingredient] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  if Coffee.instance:
    Coffee.instance.queue_free()
  Coffee.instance = self
  $RestartButton.pressed.connect(reset)
  $ServeButton.pressed.connect(serve)

func add_ingredient(type: Ingredient, liquid: PackedScene) -> void:
  current_ingredients.append(type)
  var keys := Ingredient.keys()
  var names := []
  for ing in current_ingredients:
    names.append(keys[ing])

  $Liquids.add_ingredient(liquid)

  print("[", ", ".join(names), "]")

func is_recipe_match(recipe: Array[Ingredient]) -> bool:
  print(current_ingredients)
  print(recipe)
  if recipe.size() != current_ingredients.size():
    return false

  recipe = recipe.duplicate()

  for i in current_ingredients:
    var index := recipe.find(i)
    if index == -1:
      return false
    recipe.remove_at(index)
    print(recipe)

  return true

func reset() -> void:
  current_ingredients = []
  on_reset.emit()

func serve() -> void:
  print("served")
  var dialog := AcceptDialog.new()
  dialog.theme = default_theme
  if is_recipe_match([Ingredient.A, Ingredient.A, Ingredient.C]):
    dialog.dialog_text = "This is good!"
  else:
    dialog.dialog_text = "I don't like this :("
  dialog.title = ""
  var root := get_tree().root
  root.add_child(dialog)
  dialog.show()
  dialog.position = (Vector2i(3840, 2160) - dialog.size) / 2
  reset()
  on_serve.emit()
