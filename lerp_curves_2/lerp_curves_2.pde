OpenSimplexNoise noise;
float numPoints = 80;
float radius = 0.7;
float outerRadius = 400;

void setup() {
  size(800, 800);
  frameRate(60);
  stroke(255);
  fill(255);
  
  noise = new OpenSimplexNoise();
}

float x1(float t) { return 100 * (float) noise.eval(100 + radius * cos(TWO_PI * t), radius * sin(TWO_PI * t)); }
float y1(float t) { return .1 * height + 100 * (float) noise.eval(150 + radius * cos(TWO_PI * t), radius * sin(TWO_PI * t)); }
float x2(float t) { return 100 * (float) noise.eval(600 + radius * cos(TWO_PI * t), radius * sin(TWO_PI * t)); }//(cos(t * TWO_PI) + 1) / 2.0 * width / 2.0 + width / 4; }
float y2(float t) { return .1 * height + 100 * (float) noise.eval(50 + radius * cos(TWO_PI * t), radius * sin(TWO_PI * t)); }//(sin(t * TWO_PI) + 1) / 2.0 * height / 2.0 + height / 4; }

void draw() {
  println(frameRate);
  background(0);
  translate(-20, -50);
  
  float t = frameCount % 500 / 500.0;  
  int points = 5;
  
  for(int i = 0; i < points; i++) {
    float pos = (float) i / points * TWO_PI;
    float x = width / 2 + cos(pos) * outerRadius;
    float y = height / 2 + sin(pos) * outerRadius;
    
    strokeWeight(10);
    point(width / 2 + x * outerRadius, height / 2 + y * outerRadius);
    
    for(int j = 0; j < points; j++) {
      float pos2 = (float) j / points * TWO_PI;
      float x2 = width / 2 + cos(pos2) * outerRadius;
      float y2 = height / 2 + sin(pos2) * outerRadius;
   //   line(x, y, x2, y2);
      
      pushStyle();
      strokeWeight(5);
      stroke(255, 220);
      float delay = .71;
      float lastX = x;
      float lastY = y;
      for(int k = 0; k < numPoints; k++) {
        float tt = k / numPoints;
        float xx = lerp(x1(t + noise(x) - tt * delay) + x, x2(t - (1 - tt) * delay) + x2, tt);
        float yy = lerp(y1(t + noise(x) - tt * delay) + y, y2(t - (1 - tt) * delay) + y2, tt);
        //strokeWeight((1 - k / numPoints) * 8 + 2);
        //point(xx, yy);
        line(xx, yy, lastX, lastY);
        lastX = xx;
        lastY = yy;
      }
      popStyle();
    }
  }
}