PVector[] points;
Point[] travellingPoints;
float r;
int n;
float legLength;

class Point {
  float speed;
  float lerp;
  PVector pos;
  int i;
  PVector curStart;
  PVector curEnd;
  PVector col;
  
  public Point(float speed, int index, PVector col) {
    this.speed = speed;
    this.i = index;
    this.col = col;
  }
}

void setup() {
  size(1200, 1200);
  background(140);
  
  n = 5;
  r = 400;
  points = new PVector[n];
  travellingPoints = new Point[10];
  
  for(int i = 0; i < points.length; i++) {
    float angle = (float) i / n * TWO_PI;
    points[i] = new PVector(cos(angle) * r, sin(angle) * r);
  }
  
  for(int i = 0; i < travellingPoints.length; i++) {
    float amt = (float) i / travellingPoints.length;
    travellingPoints[i] = new Point(i * 0.01, i % n, new PVector((amt + 0.3) * 200, 200, (amt + 0.4) * 200));
  }
}

void draw() {
  background(140);
  translate(width / 2, height / 2);
    
  for(int i = 0; i < points.length; i++) {
    int j = oppositePoint(i);
    float x = points[j].x;
    float y = points[j].y;
    
    line(points[i].x, points[i].y, x, y);
    legLength = dist(points[j].x, points[j].y, points[i].x, points[i].y);
  }
  
  for(int i = 0; i < travellingPoints.length; i++) {
    Point p = travellingPoints[i];
    p.lerp += p.lerp < 1 ? 0.08f * p.speed : -p.lerp;
    PVector[] pInfo = ftoStar(p.i, p.lerp);
    if(p.lerp == 0) { p.i = oppositePoint(p.i); }
    
    p.pos = pInfo[1];
    fill(p.col.x, p.col.y, p.col.z);
    ellipse(p.pos.x, p.pos.y, 20, 20);
    println(frameRate);
  }
}

int oppositePoint(int i) {
  return (i + floor(n / 2f)) % n;
}

PVector[] ftoStar(int i, float amt) { // i from 0 to n - 1, amt from 0 - 1f determines amount across leg to get position
  int j = 0;
  PVector start = points[ceil(n / 2f)];
  
  while(j != i) {
    start = points[j];
    j = oppositePoint(j);
  }
  
  PVector end = points[j];
  PVector[] ret = { end, new PVector(lerp(start.x, end.x, amt), lerp(start.y, end.y, amt)) };
  return ret;
}