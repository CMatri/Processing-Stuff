float rOrig = 200;
float n = 204;

float square(float theta) {
  return min(1. / abs(cos(theta)), 1. / abs(sin(theta)));
}

PVector[] surface(int n, boolean circle) {
  PVector[] solution = new PVector[n + 1];
  
  for(int i = 0; i <= n; i++) {
    float theta = (float) i / n * 2 * PI;
    float r = circle ? 1 : square(theta);
    solution[i] = new PVector(cos(theta) * r, sin(theta) * r);
  }
  
  return solution;
}

void setup() {
  size(1080, 1080);
  frameRate(60);
}

float ct = 0;

void draw() {
  background(0);
  
  //float max = 100;
  //n = sin(asin((n / max + (2 * PI / (frameRate * 100))) % 1)) * max;
  
  PVector[] solution = surface(int(n), false);
  PVector[] solution1 = surface(int(n), true);
    
  ct += 1 / frameRate * 0.1;
  float a = (sin(ct) + 1) * PI;
  float b = (sin(ct) + 1) * PI / 2;
  
  fill(255);
  stroke(255);
  translate(width / 2, height / 2);
  scale(rOrig);
  strokeWeight(.01);
  line(0, -height / 2, 0, height / 2);
  line(-width / 2, 0, width / 2, 0);
  strokeWeight(.03);
  for(int i = 1; i <= n; i++) {
    line(solution[i].x, solution[i].y, solution[i - 1].x, solution[i - 1].y);
    //line(solution1[i].x, solution1[i].y, solution1[i - 1].x, solution1[i - 1].y);
  }
  
  stroke(0, 255, 0);
  fill(0, 255, 0);
  line(cos(a) * square(a), sin(a) * square(a), cos(b) * square(b), sin(b) * square(b));
  ellipse(cos(a) * square(a), sin(a) * square(a), .01, .01);
  ellipse(cos(b) * square(b), sin(b) * square(b), .01, .01);
  
  //a += PI;
  //line(cos(a), sin(a), cos(b), sin(b));
  //stroke(255, 0, 0);
  //fill(255, 0, 0);
  //ellipse(cos(a), sin(a), .01, .01);
  //ellipse(cos(b), sin(b), .01, .01);
  
  float pA = square(a);
  float pB = square(b);
  float m = (pB * sin(b) - pA * sin(a)) / (pB * cos(b) - pA * cos(a));
  float d = (-pB * cos(b)) * m + (pB * sin(b));
  float c = (pB * cos(b) - pA * cos(a)) * (-pB * sin(b) + m * (pB * cos(b))) / (pB * sin(b) - pA * sin(a));
  
  stroke(255, 0, 0);
  line(c, 0, 0, d);
}