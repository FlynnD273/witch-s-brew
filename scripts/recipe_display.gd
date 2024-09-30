extends Control

@onready var image = $Drawing
@onready var text = $Text

@export var appear_duration: float = 0.5

var recipe_index: int: set = _set_recipe_index, get = _get_recipe_index
var _recipe_index: int = -1

var is_shown := false: set = _set_shown, get = _get_shown
var _is_shown := false

func _ready() -> void:
  hide()

func _process(_delta: float) -> void:
  if recipe_index == -1:
    recipe_index = 0

func _set_recipe_index(newVal: int) -> void:
  var num_recipes = Coffee.instance.recipes.size()
  _recipe_index = ((newVal % num_recipes) + num_recipes) % num_recipes
  var curr_recipe := Coffee.instance.recipes[recipe_index]
  text.text = "[center]%s[/center]\n\n" % curr_recipe.title
  var keys := curr_recipe.ingredients_dict.keys()
  var ing_names := Coffee.Ingredient.keys()
  keys.sort()
  for k in keys:
    text.text += "- %dx %s\n" % [curr_recipe.ingredients_dict[k], ing_names[k]]

  image.texture = curr_recipe.image
  var rect: Rect2 = image.get_rect()
  image.scale = Vector2.ONE * 512 / rect.size.x * 1.41

func _get_recipe_index() -> int:
  return _recipe_index


func _on_next_button_pressed() -> void:
  recipe_index += 1


func _on_prev_button_pressed() -> void:
  recipe_index -= 1

func toggle_visibility() -> void:
  is_shown = !is_shown

func _set_shown(newValue: bool) -> void:
  _is_shown = newValue
  if is_shown:
    position = Vector2.DOWN * 100 + Vector2(1920, 1080)
    scale = Vector2.ONE * 0.8
    modulate = Color(1, 1, 1, 0)
    var tween := create_tween()
    tween.tween_property(self, "position", Vector2(1920, 1080), appear_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    tween = create_tween()
    tween.tween_property(self, "scale", Vector2.ONE, appear_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    tween = create_tween()
    tween.tween_property(self, "modulate", Color.WHITE, appear_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    show()
    get_tree().paused = true
  else:
    position = Vector2(1920, 1080)
    scale = Vector2.ONE
    modulate = Color.WHITE
    var tween := create_tween()
    tween.tween_property(self, "position", Vector2.DOWN * 100 + Vector2(1920, 1080), appear_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    tween = create_tween()
    tween.tween_property(self, "scale", Vector2.ONE * 0.8, appear_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    tween = create_tween()
    tween.tween_property(self, "modulate", Color(1, 1, 1, 0), appear_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    var tree := get_tree()
    tree.paused = false

    await tree.create_timer(appear_duration).timeout
    if !is_shown:
      hide()

func _get_shown() -> bool:
  return _is_shown
