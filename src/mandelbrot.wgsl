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

    // Define the point to zoom into
    let zoom_point = vec2<f32>(-0.75, 0.1); // Example point at the edge of the set

    // Dynamically adjust zoom level based on time
    let zoom_factor = zoom * pow(1.75, time); // Zoom in over time, increasing the base by a small factor


    // Compute Mandelbrot coordinates
    let coord = vec2<f32>(
        (input.position.x / width - 0.5) * 3.0 / zoom_factor + zoom_point.x,
        (input.position.y / height - 0.5) * 2.0 / zoom_factor + zoom_point.y
    );

    var z = vec2<f32>(0.0, 0.0);
    let c = coord;

    var iter: i32 = 0;
    let max_iter = 100;
    var escaped = false;

    // Mandelbrot equation iteration loop
    while (iter < max_iter && dot(z, z) < 4.0) {
        z = vec2<f32>(z.x * z.x - z.y * z.y + c.x, 2.0 * z.x * z.y + c.y);
        iter = iter + 1;
        if (dot(z, z) >= 4.0) {
            escaped = true;
            break;
        }
    }

    // Color based on the number of iterations until escape
    if escaped {
        let escape_value = f32(iter) / f32(max_iter); // Normalize to [0, 1]
        return vec4<f32>(escape_value, escape_value * 0.5, escape_value * 0.25, 1.0);
    } else {
        // Color black for points inside the set
        return vec4<f32>(0.0, 0.0, 0.0, 1.0);
    }
}