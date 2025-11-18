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
  gl_FragColor = vec4(
    MAX_VALUE, MAX_VALUE, 
    MIN_VALUE, MIN_VALUE
  );
}
