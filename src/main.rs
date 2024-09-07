use wgpu::util::DeviceExt;

async fn run() {
    // Create an instance for GPU communication
    let instance = wgpu::Instance::new(wgpu::Backends::all());

    // Request the first available adapter
    let adapter = instance.request_adapter(&wgpu::RequestAdapterOptions {
        power_preference: wgpu::PowerPreference::HighPerformance,
        compatible_surface: None,
        force_fallback_adapter: false,
    }).await.unwrap();

    // Create a device and queue
    let (device, queue) = adapter.request_device(
        &wgpu::DeviceDescriptor {
            features: wgpu::Features::empty(),
            limits: wgpu::Limits::default(),
            label: None,
        },
        None, // Trace path
    ).await.unwrap();

    println!("wgpu is successfully set up!");
}

fn main() {
    // Block until the async GPU setup is complete
    pollster::block_on(run());
}
