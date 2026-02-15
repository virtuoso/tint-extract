var<private> out_color : vec4<f32>;

fn main_inner() {
  out_color = vec4<f32>(1.0f, 0.0f, 0.0f, 1.0f);
}

@fragment
fn main() -> @location(0u) vec4<f32> {
  main_inner();
  return out_color;
}
