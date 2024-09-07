// mandelbrot.wgsl
@group(0) @binding(0) var<uniform> zoom: f32;
@group(0) @binding(1) var<uniform> time: f32;

struct VertexOutput {
    @builtin(position) position: vec4<f32>,
};

@vertex
fn vs_main(@builtin(vertex_index) vertex_index: u32) -> VertexOutput {
    var pos = array<vec2<f32>, 3>(
        vec2<f32>(-1.0, -1.0),
        vec2<f32>( 3.0, -1.0),
        vec2<f32>(-1.0,  3.0)
    );
    var output: VertexOutput;
    output.position = vec4<f32>(pos[vertex_index], 0.0, 1.0);
    return output;
}

@fragment
fn fs_main(input: VertexOutput) -> @location(0) vec4<f32> {
    let width: f32 = 800.0;
    let height: f32 = 600.0;
    let coord = vec2<f32>((input.position.x / width - 0.5) * 3.0 / zoom, (input.position.y / height - 0.5) * 2.0 / zoom);

    var z = vec2<f32>(0.0, 0.0);
    let c = coord;

    var iter: i32 = 0;
    let max_iter = 100;

    while (iter < max_iter && dot(z, z) < 4.0) {
        z = vec2<f32>(z.x * z.x - z.y * z.y + c.x, 2.0 * z.x * z.y + c.y);
        iter = iter + 1;
    }

    let color = vec3<f32>(f32(iter) / f32(max_iter), 0.5 + 0.5 * sin(time), 0.5);
    return vec4<f32>(color, 1.0);
}