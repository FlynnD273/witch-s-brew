shader_type canvas_item;

uniform float outline_alpha = 1.;
uniform vec3 outline_color = vec3(1, 1, 1);
uniform float search_radius = 0.02;

void fragment() {
    float alpha = 0.;
    if (texture(TEXTURE, UV).a < 0.5) {
      for (float x = -search_radius; x <= search_radius; x += search_radius / 3.) {
          for (float y = -search_radius; y <= search_radius; y += search_radius / 3.) {
              vec2 offset = vec2(x, y);
              float sample_alpha = texture(TEXTURE, UV + offset).a;
              if (sample_alpha > alpha) {
                alpha = sample_alpha;
              }
          }
      }
    }

    if (alpha > 0.) {
      COLOR = vec4(outline_color.x, outline_color.y, outline_color.z, alpha * outline_alpha);
    }
}
