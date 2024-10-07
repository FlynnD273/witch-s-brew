extends TextureRect

var inc_height: float = 100
@export var reset_duration: float = 1
@export var pour_duration: float = 0.5

var ingredients: Array[Control] = []

func _on_coffee_on_reset() -> void:
  for i in ingredients:
    var tween := create_tween()
    tween.tween_property(i, "position", $Coffee.position + Vector2.DOWN * inc_height, reset_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
  var old_ingredients:= ingredients.duplicate()
  ingredients = []

  await get_tree().create_timer(reset_duration).timeout

  for i in old_ingredients:
    i.queue_free()


func add_ingredient(new_ing: Color) -> void:
  var num_ing := ingredients.size()
  print(num_ing)
  var i: ColorRect = ColorRect.new()
  i.size = Vector2(1200, 100)
  i.color = new_ing
  i.position = $Coffee.position + Vector2.UP * inc_height * num_ing
  add_child(i)
  move_child(i, 0)
  var tween = create_tween()
  ingredients.append(i)
  tween.tween_property(i, "position", $Coffee.position + Vector2.UP * inc_height * (num_ing + 1), pour_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
  await get_tree().create_timer(pour_duration).timeout
