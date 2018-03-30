float n = 1;
float rOrig = 200;

float square(float theta) {
  return min(1. / abs(cos(theta)), 1. / abs(sin(theta)));
}

PVector[] surface(int n, boolean circle) {
  PVector[] solution = new PVector[n + 1];
  
  for(int i = 0; i <= n; i++) {
    float theta = (float) i / n * 2 * PI;
    float r = circle ? rOrig : square(theta) * rOrig;
    solution[i] = new PVector(cos(theta) * r, sin(theta) * r);
  }
  
  return solution;
}

void setup() {
  size(1080, 1080);
  frameRate(60);
}

void draw() {
  background(0);
  
  float max = 100;
  n = sin(asin((n / max + (2 * PI / (frameRate * 100))) % 1)) * max;
  
  PVector[] solution = surface(int(n), false);
  PVector[] solution1 = surface(int(n), true);
    
  translate(width / 4, height / 2);
  for(int i = 1; i < n; i++) {
    fill(0, (float) i / n * 255, 0, 200);
    stroke(255 - (float) i / n * 255, (float) i / n * 255, 0, 200);
    strokeWeight(5);
    line(solution[i].x, solution[i].y, solution1[i].x + width / 2, solution1[i].y);  
    fill(255);
    stroke(255);
    strokeWeight(3);
    line(solution[i].x, solution[i].y, solution[i - 1].x, solution[i - 1].y);
    line(solution1[i].x + width / 2, solution1[i].y, solution1[i - 1].x + width / 2, solution1[i - 1].y);
  }
}