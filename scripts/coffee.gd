extends Control


class_name Coffee

enum Ingredient {
  SteamedWishes,
  Zestroot,
  Mushmellow,
}

static var instance: Coffee = null

const default_theme: Theme = preload("res://default_theme.tres")
var current_ingredients: Array[Ingredient] = []

@onready var ingredient_label = $IngredientLabel

signal on_reset
signal on_serve

func _ready() -> void:
  Coffee.instance = self
  $RestartButton.pressed.connect(reset)
  $ServeButton.pressed.connect(serve)

func add_ingredient(type: Ingredient, liquid: PackedScene) -> void:
  if type in current_ingredients:
    return
  current_ingredients.append(type)
  $Liquids.add_ingredient(liquid)

func reset() -> void:
  current_ingredients = []
  on_reset.emit()

func serve() -> void:
  on_serve.emit()
  hide()
