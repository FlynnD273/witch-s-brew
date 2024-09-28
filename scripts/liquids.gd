extends TextureRect

var inc_height: float = 100
var start_pos := Vector2(500, 1900)
@export var reset_duration: float = 1
@export var pour_duration: float = 0.5

var ingredients: Array[Node2D] = []

func _on_coffee_on_reset() -> void:
  for i in ingredients:
    var tween := create_tween()
    tween.tween_property(i, "position", start_pos + Vector2.DOWN * inc_height, reset_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
  var old_ingredients:= ingredients.duplicate()
  ingredients = []

  await get_tree().create_timer(reset_duration).timeout

  for i in old_ingredients:
    i.queue_free()


func add_ingredient(new_ing: PackedScene) -> void:
  var i: Node2D = new_ing.instantiate()
  i.position = start_pos + Vector2.UP * inc_height * (ingredients.size() - 1)
  add_child(i)
  move_child(i, 0)
  var tween = create_tween()
  tween.tween_property(i, "position", start_pos + Vector2.UP * inc_height * ingredients.size(), pour_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
  ingredients.append(i)
