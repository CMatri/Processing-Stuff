uniform float srcSize;
uniform vec2 mouse;

void main()
{
  if(abs(mouse - gl_FragCoord.xy) < srcSize)
    gl_FragColor = vec4()
  else
    gl_FragColor = vec4(0.0)
}
