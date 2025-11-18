// Header.
precision float highp;


// Uniforms.
uniform vec2 FSH_baseTexels;


// Declare functions
vec4 Get(vec2 pos, vec2 offset);


// Main function.
void main()
{
  // Get 2x2 block position in the source.
  vec2 block = floor(gl_FragCoord.xy) * 2.0 + 0.5;
  
  // Get the samples within the 2x2 block.
  vec4 sample00 = Get(block, vec2(0.0, 0.0));
  vec4 sample01 = Get(block, vec2(0.0, 1.0));
  vec4 sample10 = Get(block, vec2(1.0, 0.0));
  vec4 sample11 = Get(block, vec2(1.0, 1.0));
  
  // Reduce the block : Find the minimum and maximum of 2x2 area.
  vec2 minimum = min(sample00.xy, min(sample01.xy, min(sample10.xy, sample11.xy)));
  vec2 maximum = max(sample00.zw, max(sample01.zw, max(sample10.zw, sample11.zw)));
  
  // Store the result.
  gl_FragColor = vec4(minimum, maximum);
}


// Define functions.
vec4 Get(vec2 pos, vec2 offset)
{
  return texture2D(gm_BaseTexture, (pos + offset) * FSH_baseTexels);
}