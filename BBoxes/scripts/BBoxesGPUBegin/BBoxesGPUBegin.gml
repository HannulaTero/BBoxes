

/**
* Set the GPU state.
*/ 
function BBoxesGPUBegin()
{
  // Create the state.
  static gpuState = method_call(function() 
  {
    // Create a new GPU state.
    gpu_push_state();
    gpu_set_colorwriteenable(true, true, true, true);
    gpu_set_alphatestenable(false);
    gpu_set_blendenable(false);
    gpu_set_zwriteenable(false);
    gpu_set_ztestenable(false);
    gpu_set_stencil_enable(false);
    gpu_set_tex_filter(false);
    gpu_set_tex_repeat(false);
    gpu_set_tex_mip_enable(false);
    gpu_set_fog(false, c_white, 1, 2);
    gpu_set_cullmode(cull_noculling);
    
    // Return the state.
    var _state = gpu_get_state();
    gpu_pop_state();
    return _state;
  });
  
  
  // Apply the state.
  gpu_push_state();
  gpu_set_state(gpuState);
  gpu_set_blendequation(bm_eq_add);
  
  
  // If there was some shader, sorry it has to go.
  var _shader = shader_current();
  if (_shader != -1)
  {
    shader_reset();
  }
}