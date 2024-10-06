extends DialogicPortrait

@export_file var image := ""

## If the custom portrait accepts a change, then accept it here
## You should position your portrait so that the root node is at the pivot point*.
## For example for a simple $Sprite this code would work:
## >>> $Sprite.position = $Sprite.get_rect().size * Vector2(-0.5, -1)
##
## * this depends on the portrait containers, but it will most likely be the bottom center (99% of cases)
func _update_portrait(_passed_character: DialogicCharacter, _passed_portrait: String) -> void:
  # print(passed_character.get_portrait_info(passed_portrait))
  # var path: String = passed_character.get_portrait_info(passed_portrait)['export_overrides']['image']
  # path = path.substr(1, path.length() - 2)
  # var tex: CompressedTexture2D = load(path)
  $Sprite.texture = load(image)

## This should be implemented. It is used for sizing in the
## character editor preview and in portrait containers.
## Scale and offset will be applied by Dialogic.
## For example, a simple $Sprite:
## >>> return Rect2($Sprite.position, $Sprite.get_rect().size)
##
## This will only work as expected if the portrait is positioned so that the
## root is at the pivot point.
##
## If you've used apply_texture this should work automatically.
func _get_covered_rect() -> Rect2:
  return Rect2($Sprite.position, $Sprite.get_rect().size)

func _process(_delta: float) -> void:
  var sprite: TextureRect = $Sprite
  sprite.material.set_indexed("shader_parameter/outline_alpha", modulate.a)
