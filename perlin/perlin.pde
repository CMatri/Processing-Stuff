int w, h, gw, gh, scl;
float[][] noiseVals;

void setup() {
  size(1920, 1080, P3D);
  background(0);
  
  w = 3000;
  h = 3000;
  scl = 30;
  gw = w / scl;
  gh = h / scl;
  noiseVals = new float[gw][gh];
}

float pX = 0, py = 0;
long prev;

void draw() {
  double dt = (-prev + (prev = frameRateLastNanos)) / 1e6d;
  float mv = (float) (0.002 * dt);
  
  if(keyCode == UP)
    py -= mv;
  if(keyCode == DOWN)
    py += mv;
  if(keyCode == LEFT)
    pX -= mv;
  if(keyCode == RIGHT)
    pX += mv;
  
  for(int y = 0; y < gh; y++) {
    for(int x = 0; x < gw; x++) {
      noiseVals[x][y] = map(noise(x / 20.0 + pX, y / 20.0 + py), 0, 1, -200, 300) * 1.5;
    }
  }
  
  println(frameRate);
  background(0);
  stroke(255);
  noFill();
  
  translate(width / 2 - w / 2, height / 2);
  rotateX(-PI / 5);
  translate(0, 0, -h + 600);
  
  for(int y = 0; y < gh - 1; y++) {
    beginShape(TRIANGLE_STRIP);
    for(int x = 0; x < gw; x++) {
      vertex(x * scl, noiseVals[x][y], y * scl);
      vertex(x * scl, noiseVals[x][y + 1], (y + 1) * scl);
    }
    endShape();
  }
}