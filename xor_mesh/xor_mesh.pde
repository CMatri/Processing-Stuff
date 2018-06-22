import ComputationalGeometry.*;
import queasycam.*;

IsoWrap iso;
QueasyCam cam;

int n = 200;
float val = 0;
float depth = 2000;
float x = 0;
float y = 0;
float z = 0;
float size = 200;

void setup() {
  size(1000, 1000, P3D);
  
  iso = new IsoWrap(this);
      
  for(int i = 0; i < n; i++) {
    x = (float) i / n * size;
    for(int j = 0; j < n; j++) {
      y = (float) j / n * size;
      for(int k = 0; k < n; k++) {
        z = (float) k / n * size;
        if((i ^ j) == k) {
        //if(x == y*0.2 || y == z) {
          //point(x, y, z);
          PVector pt = new PVector(x + sin((float) i / n * TWO_PI) * 50.0, y, z);
          iso.addPt(pt);
        }
      }
    }
  }
  
  cam = new QueasyCam(this);
  cam.speed = 2;
  cam.sensitivity = 0.5;
}

void draw() {
  //camera(150,150,150,50,50,40,0,0,-1);
  lights();
  background(220);
  
  
  
  frustum(-10, 10, -10, 10, 10, 4000);
  iso.plot();

//  val += val < n ? 0.1 : -val;
  
  //fill(255);
  //strokeWeight(10);
  //stroke(255);
}