float r = 400 / 2f;
float theta = 0;
float x = cos(theta);
float y = sin(theta);

void setup() {
  size(800, 800);
  frameRate(60);
}

void drawGraph() {
  translate(width / 2, height / 2);
  stroke(0);
  line(-width / 2f, 0, width / 2f, 0);  
  line(0, -height / 2f, 0, height / 2f);  
  stroke(0);
  strokeWeight(5);
  fill(0, 0, 0, 0);
  ellipse(0, 0, r*2f, r*2f);
  
  float x = cos(theta) * r;
  float y = sin(theta) * r;
  
  stroke(255, 100, 100);
  line(x, 0, x, y);
  line(0, y, x, y);
  stroke(100, 200, 100);
  arc(0, 0, 60, 60, 0, theta);
  stroke(0);
  line(0, 0, x, y);
  stroke(0, 0, 255);
  line(0, 0, 1f / cos(theta) * r, 0);
  stroke(255, 0, 0);
  line(0, 0, 0, 1f / sin(theta) * r);
  
  rotate(theta);
  stroke(255, 0, 255);
  line(r, 0, r, -tan(theta) * r);
  stroke(0, 255, 0);
  line(r, 0, r, 1f / tan(theta) * r);
}

void draw() {
  background(255);
  pushMatrix();
  drawGraph();
  popMatrix();
  
  theta += .005f;
  if(degrees(theta) >= 360) theta = 0;
}