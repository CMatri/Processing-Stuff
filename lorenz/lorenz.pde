import peasy.*;

float a = 10;
float b = 30;
float c = 8.0 / 4.0;
float x = 1, y = 1, z = 2;
float dt = 0.01;

ArrayList<PVector> verts = new ArrayList<PVector>();
PeasyCam cam;

void setup() {
  size(1920, 1080, P3D);
  background(65);
  colorMode(HSB);
  //cam = new PeasyCam(this, 0, 0, 0, 50);

  for(int i = 0; i < 10000; i++) {
    x += (a * (y - x)) * dt;  
    y += (x * (b - z) - y) * dt;
    z += (x * y - c * z) * dt;
    
    verts.add(new PVector(x, y, z));
  }
}

float omx = 0;
float theta = 0;

void draw() {
  background(65);  
  translate(width / 2, height / 2);
  scale(5);
  noFill();
  strokeWeight(0.2);
  
  if(mousePressed) theta += (omx - mouseX) / 200.0;
  float h = 0;
  
  beginShape();
  for(PVector v : verts) {
    float zrot = v.z * cos(theta) - v.x * sin(theta);
    float xrot = v.z * sin(theta) + v.x * cos(theta);
    
    h += 0.2;
    strokeWeight((sin(h / 8.0) + 1.3) / 2.0);
    stroke(h % 255, 255, 255);
    vertex(v.x + xrot, v.y, v.z + zrot);
  }
  endShape();
  
  omx = mouseX;
}