// Header.
precision highp float;

// Varyings.
varying vec2 vCoord;

// Uniforms.
uniform float FSH_threshold;
uniform vec2 FSH_offset;

// Define.
#define MAX_VALUE 16384.0
#define MIN_VALUE -1.0

// Main function.
void main()
{
  // Get the sample.
  vec4 sample = texture2D(gm_BaseTexture, vCoord);
  
  // Check whether part of image.
  if (sample.a > FSH_threshold)
  {
    vec2 position = floor(gl_FragCoord.xy) - FSH_offset;
    gl_FragColor = vec4(position, position);
    return;
  }
  
  // Otherwise it's considered as a empty pixel.
  gl_FragColor = vec4(
    MAX_VALUE, MAX_VALUE, 
    MIN_VALUE, MIN_VALUE
  );
}
