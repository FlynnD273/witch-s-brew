extends Control

class_name Coffee

enum Ingredient {
  A,
  B,
  C,
  D,
}

static var instance: Coffee = null

const default_theme: Theme = preload("res://default_theme.tres")
var recipes: Array[Recipe] = []

signal on_reset
signal on_serve


var current_ingredients: Array[Ingredient] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  if Coffee.instance:
    Coffee.instance.queue_free()
  Coffee.instance = self
  $RestartButton.pressed.connect(reset)
  $ServeButton.pressed.connect(serve)
  
  for recipe in $Recipes.get_children():
    if is_instance_of(recipe, Recipe):
      recipes.append(recipe)

  print(recipes)


func add_ingredient(type: Ingredient, liquid: PackedScene) -> void:
  current_ingredients.append(type)
  var keys := Ingredient.keys()
  var names := []
  for ing in current_ingredients:
    names.append(keys[ing])

  $Liquids.add_ingredient(liquid)

  print("[", ", ".join(names), "]")

func get_recipe() -> Recipe:
  var ingredients_dict := {}
  for i in current_ingredients:
    if ingredients_dict.has(i):
      ingredients_dict[i] += 1
    else:
      ingredients_dict[i] = 1

  for r in recipes:
    if ingredients_dict == r.ingredients_dict:
      return r

  return null

func reset() -> void:
  current_ingredients = []
  on_reset.emit()

func serve() -> void:
  print("served")
  var dialog := AcceptDialog.new()
  dialog.theme = default_theme
  var recipe := get_recipe()
  if recipe:
    dialog.dialog_text = "I like this %s drink!" % recipe.title
  else:
    dialog.dialog_text = "I don't like this :("
  dialog.title = ""
  var root := get_tree().root
  root.add_child(dialog)
  dialog.show()
  dialog.position = (Vector2i(3840, 2160) - dialog.size) / 2
  reset()
  on_serve.emit()
