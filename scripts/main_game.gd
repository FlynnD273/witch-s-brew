extends Control

class_name MainGame

enum Characters {
  Solephanie,
  Darnery,
  Oak,
  Koaraok,
  Olga,
  HintO,
  Humphrey,
}

static var instance: MainGame = null

var day: int = 1
var mixes: Array = [[], [Coffee.Ingredient.SteamedWishes], [Coffee.Ingredient.Zestroot], [Coffee.Ingredient.Mushmellow], [Coffee.Ingredient.SteamedWishes, Coffee.Ingredient.Zestroot], [Coffee.Ingredient.SteamedWishes, Coffee.Ingredient.Mushmellow], [Coffee.Ingredient.Zestroot, Coffee.Ingredient.Mushmellow], [Coffee.Ingredient.Zestroot, Coffee.Ingredient.SteamedWishes, Coffee.Ingredient.Mushmellow]]
var characterStats: Dictionary = {}
@export var coffee_scene: PackedScene = preload("res://scenes/coffee_manager.tscn")

var should_init = true

func init() -> void:
  instance = self
  var blank_dict: Dictionary = {}
  for i in Coffee.Ingredient:
    blank_dict[i] = 0
  for chara in Characters:
    characterStats[chara] = blank_dict.duplicate()

func _process(_delta: float) -> void:
  if should_init:
    should_init = false
  else:
    return

  init()

  dayTransition()
  var cof = await make_coffee()
  print(cof.map(func (i): return Coffee.Ingredient.keys()[i]))

func newDay() -> void:
  day += 1
  dayTransition()

func dayTransition() -> void:
  pass

func get_mix_num(ingredients: Array[Coffee.Ingredient]) -> int:
  for i in range(1, mixes.size()):
    var mix: Array[Coffee.Ingredient] = mixes[i]
    if mix.size() != ingredients.size():
      continue
    var is_good := true
    for ing in mix:
      if not ing in ingredients:
        is_good = false
        break
    if is_good:
      return i
  return -1

func make_coffee() -> Array[Coffee.Ingredient]:
  var cof: Coffee = coffee_scene.instantiate()
  get_tree().root.add_child(cof)
  cof.show()
  await cof.on_serve
  cof.queue_free()
  return cof.current_ingredients
