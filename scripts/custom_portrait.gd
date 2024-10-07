extends DialogicPortrait

@export_file var image := ""

func _update_portrait(passed_character: DialogicCharacter, passed_portrait: String) -> void:
  apply_character_and_portrait(passed_character, passed_portrait)
  apply_texture($Sprite, image)

# func _get_covered_rect() -> Rect2:
#   return Rect2($Sprite.position, $Sprite.get_rect().size)

func _set_mirror(is_mirrored: bool) -> void:
  $Sprite.flip_h = is_mirrored

func _late_process(_delta: float) -> void:
  var sprite: TextureRect = $Sprite
  sprite.material.set_indexed("shader_parameter/outline_alpha", modulate.a)

func _highlight() -> void:
  var tween := create_tween()
  tween.tween_property(self, "modulate", Color.WHITE, 0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)

func _unhighlight() -> void:
  var tween := create_tween()
  tween.tween_property(self, "modulate", Color(0.5, 0.5, 0.5), 0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)

func _set_extra_data(data: String) -> void:
  if data == "dim":
    _unhighlight()
