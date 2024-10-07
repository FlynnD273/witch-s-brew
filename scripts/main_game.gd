extends Control

class_name MainGame

enum Character {
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
var last_drink: int
@export var coffee_scene: PackedScene = preload("res://scenes/coffee_manager.tscn")
@onready var trans := $Transition

var should_init = true

func init() -> void:
  instance = self
  var blank_dict: Dictionary = {}
  for i in range(mixes.size()):
    blank_dict[i] = 0
  for chara in Character.values():
    characterStats[chara] = blank_dict.duplicate()
  day = 0

func _process(_delta: float) -> void:
  if should_init:
    should_init = false
  else:
    return

  init()

  await get_tree().create_timer(1).timeout
  await day_zero()

  await new_day()
  await day_one()

  await new_day()
  await day_two()

  await new_day()
  await day_three()

  await new_day()
  await day_four()

  await trans.transition("The End")

func day_four() -> void:
  if characterStats[Character.Solephanie][4] == 3:
    await start_timeline("sol_3_4_1")
    var loop := true
    while loop:
      last_drink = await make_coffee()
      loop = false
      match last_drink:
        4:
          pass
        _:
          await start_timeline("sol_3_4_1_reject")
          loop = true
    give_mix(Character.Solephanie, last_drink)
    await start_timeline("sol_3_4_2")
  elif characterStats[Character.Solephanie][5] == 3:
    await start_timeline("sol_3_5_1")
    var loop := true
    while loop:
      last_drink = await make_coffee()
      loop = false
      match last_drink:
        5:
          pass
        _:
          await start_timeline("sol_3_5_1_reject")
          loop = true
    give_mix(Character.Solephanie, last_drink)
    await start_timeline("sol_3_5_2")
  elif characterStats[Character.Solephanie][4] == 2:
    await start_timeline("sol_2_4_1_5_1")
    var loop := true
    while loop:
      last_drink = await make_coffee()
      loop = false
      match last_drink:
        5:
          pass
        _:
          await start_timeline("sol_3_4_1_reject")
          loop = true
    give_mix(Character.Solephanie, last_drink)
    await start_timeline("sol_2_4_1_5_2")
  else:
    await start_timeline("sol_1_4_2_5_1")
    var loop := true
    while loop:
      last_drink = await make_coffee()
      loop = false
      match last_drink:
        4:
          pass
        5:
          pass
        _:
          await start_timeline("sol_1_4_2_5_1_reject")
          loop = true
    give_mix(Character.Solephanie, last_drink)


  await start_timeline("outro_1")
  await make_coffee()
  await start_timeline("outro_2")

func day_three() -> void:
  if characterStats[Character.Solephanie][4] == 2:
    await start_timeline("sol_2_4_1")
    await serve_dar()
    await start_timeline("sol_2_4_2")

    await start_timeline("sol_2_4_3")
    await serve_sol()
  elif characterStats[Character.Solephanie][5] == 2:
    await start_timeline("sol_2_5_1")
    await serve_dar()
    await start_timeline("sol_2_5_2")
    give_mix(Character.Darnery, last_drink)

    await start_timeline("sol_2_5_3")
    await serve_sol()
  else:
    await start_timeline("sol_1_4_1_5_1")
    await serve_sol()

func day_two() -> void:
  await start_timeline("darnery_intro")
  var loop := true
  while loop:
    last_drink = await make_coffee()
    loop = false
    match last_drink:
      0:
        await start_timeline("darnery_accept")
      _:
        await start_timeline("darnery_reject")
        loop = true
  give_mix(Character.Darnery, last_drink)
  await trans.transition("Later in the same day...")
  if characterStats[Character.Solephanie][4] == 1:
    await start_timeline("sol_2_mix_4")
    await serve_sol()
  else:
    await start_timeline("sol_2_mix_5")
    await serve_sol()

func day_one() -> void:
  await start_timeline("intro")
  var loop := true
  while loop:
    last_drink = await make_coffee()
    loop = false
    match last_drink:
      1:
        await start_timeline("intro_mix1")
        loop = true
      4:
        await start_timeline("intro_mix4")
      5:
        await start_timeline("intro_mix5")
      _:
        await start_timeline("intro_reject")
        loop = true
  give_mix(Character.Solephanie, last_drink)

func day_zero() -> void:
  await start_timeline("1")
  var cof: Coffee = coffee_scene.instantiate()
  get_tree().root.add_child(cof)
  cof.show()
  await start_timeline("2")
  await cof.on_serve
  cof.queue_free()
  await start_timeline("3")

func new_day() -> void:
  day += 1
  await day_trans()

func day_trans() -> void:
  await trans.transition("Day %d" % day)

func get_mix_num(ingredients: Array[Coffee.Ingredient]) -> int:
  for i in range(mixes.size()):
    var mix: Array[Coffee.Ingredient]
    mix.assign(mixes[i])
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

func make_coffee() -> int:
  var cof: Coffee = coffee_scene.instantiate()
  get_tree().root.add_child(cof)
  cof.show()
  await cof.on_serve
  cof.queue_free()
  return get_mix_num(cof.current_ingredients)

func start_timeline(title: String) -> void:
  Dialogic.start(load("res://dialogue/timelines/day%d/%s.dtl" % [day, title]))
  await Dialogic.timeline_ended

func give_mix(chara: Character, mix_num: int) -> void:
  characterStats[chara][mix_num] += 1

func serve_sol() -> void:
  var loop := true
  while loop:
    last_drink = await make_coffee()
    loop = false
    match last_drink:
      4:
        pass
      5:
        pass
      _:
        Dialogic.start(load("res://dialogue/timelines/sol_reject.dtl"))
        await Dialogic.timeline_ended
        loop = true
  give_mix(Character.Solephanie, last_drink)

func serve_dar() -> void:
  var loop := true
  while loop:
    last_drink = await make_coffee()
    loop = false
    match last_drink:
      0:
        pass
      _:
        Dialogic.start(load("res://dialogue/timelines/darnery_reject.dtl"))
        await Dialogic.timeline_ended
        loop = true
  give_mix(Character.Darnery, last_drink)
