uniform bool use_lines;
uniform vec3 dims;
uniform float dim;

in float brightness_out;
out vec4 color_out;

void main (void) {
   if (use_lines) {
      color_out = vec4(1.0, 1.0, 1.0, brightness_out*dim);
   }
   else {
      float d = length( gl_PointCoord*2.0-1.0 )-1.0;
      float a = smoothstep( 0.0, 1.0, -d );
      color_out = vec4(1.0, 1.0, 1.0, brightness_out*a*dim);
   }
}
