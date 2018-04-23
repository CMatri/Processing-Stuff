OpenSimplexNoise noise;
float numPoints = 800;
float radius = 4.5;

void setup() {
  size(1000, 1000);
  frameRate(60);
  stroke(255);
  fill(255);
  
  noise = new OpenSimplexNoise();
}

float x1(float t) { return 100 * (float) noise.eval(100 + radius * cos(TWO_PI * t), radius * sin(TWO_PI * t)); }
float y1(float t) { return .1 * height + 100 * (float) noise.eval(150 + radius * cos(TWO_PI * t), radius * sin(TWO_PI * t)); }
float x2(float t) { return .5 * width;}//(cos(t * TWO_PI) + 1) / 2.0 * width / 2.0 + width / 4; }
float y2(float t) { return .95 * height;}//(sin(t * TWO_PI) + 1) / 2.0 * height / 2.0 + height / 4; }

void draw() {
  background(0);
  
  float t = frameCount % 500 / 500.0;  
  
  //ellipse(x1(t), y1(t), 15, 15);
  //ellipse(x2(t), y2(t), 15, 15);
  pushStyle();
  strokeWeight(4);
  stroke(255, 100);
  float delay = .71;
  for(float x_off = 0; x_off < width; x_off += width / 6.0) {
    for(int i = 0; i < numPoints; i++) {
      float tt = i / numPoints;
      float x = lerp(x1(t + noise(x_off) - tt * delay) + x_off + width / 12., x2(t - (1 - tt) * delay), tt);
      float y = lerp(y1(t + noise(x_off) - tt * delay) - sin(x_off / width * PI) * 200 + 200, y2(t - (1 - tt) * delay), tt);
      
      point(x, y);
    }
  }
  popStyle();
}