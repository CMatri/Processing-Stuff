float px = 0;
float py = 0;
PShader blur;

void setup() {
  size(1000, 1000, P3D);
  frameRate(60);
  background(100);
  blur = loadShader("blur.glsl");
}

void draw() {
  filter(blur);
  //if(frameCount % 100 == 0) background(100, 100, 100, 20);
  //background(0);
  px = cos(frameCount % 400f / 400f * TWO_PI);
  py = sin(frameCount % 400f / 400f * TWO_PI);

  pushStyle();
  fill(20, 30);
  rect(0, 0, width, height);
  popStyle();
  
  stroke(255);
  fill(255);
  strokeWeight(10);
  point(width / 2f + px * 300 + (noise((frameCount - 500) / 50f) - 0.5) * 150, height / 2f + py * 300 + (noise(frameCount / 50f) - 0.5) * 150);
}