extends Control

@export var left_pages: Array[Control] = []
@export var right_pages: Array[Control] = []
@export var turn_duration: float = 1

var page_index: int = 0
var is_turning: bool = false
var queue_turn: bool = false

func _ready() -> void:
  for i in range(left_pages.size()):
    left_pages[i].pivot_offset = $Center.position
    right_pages[i].pivot_offset = $Center.position
    if i == page_index:
      continue

    left_pages[i].hide()
    right_pages[i].hide()
  $NextPage.pressed.connect(next_page)

func _process(_delta: float) -> void:
  if not is_turning and queue_turn:
    next_page()

func next_page() -> void:
  if is_turning:
    queue_turn = true
    return
  queue_turn = false
  is_turning = true
  var next_index := (page_index + 1) % left_pages.size()
  move_child(right_pages[page_index], -1)
  right_pages[next_index].scale = Vector2.ONE
  right_pages[next_index].show()
  var tween := create_tween()
  tween.tween_property(right_pages[page_index], "scale", Vector2(0, 1), turn_duration / 2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
  await get_tree().create_timer(turn_duration / 2).timeout
  right_pages[page_index].hide()
  move_child(left_pages[next_index], -1)
  left_pages[next_index].scale = Vector2(0, 1)
  left_pages[next_index].show()
  tween = create_tween()
  tween.tween_property(left_pages[next_index], "scale", Vector2.ONE, turn_duration / 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
  await get_tree().create_timer(turn_duration / 2).timeout
  left_pages[page_index].hide()
  page_index = next_index
  is_turning = false
