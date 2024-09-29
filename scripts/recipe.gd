extends Node

class_name Recipe

@export var ingredients: Array[Coffee.Ingredient] = []
@export var image: Texture2D = null
@export var title: String = ""

var ingredients_dict: Dictionary

func _ready() -> void:
  ingredients_dict = {}
  for i in ingredients:
    if ingredients_dict.has(i):
      ingredients_dict[i] += 1
    else:
      ingredients_dict[i] = 1

  if not title:
    title = name
