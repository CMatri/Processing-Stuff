import queasycam.*;

int n = 50;
float val = 0;
float depth = 2000;
QueasyCam cam;

void setup() {
  size(2000, 2000, P3D);
  background(0);
  
  cam = new QueasyCam(this);
  cam.speed = 2;
  cam.sensitivity = 0.5;
}

void draw() {
  background(100);
  frustum(-10, 10, -10, 10, 10, 4000);
  
  float x = 0;
  float y = 0;
  float z = 0;
  
  val += val < n ? 0.1 : -val;
  
  fill(255, 0.1);
  strokeWeight(20);
  stroke(255, 0.1);
  
  for(int i = 0; i < n; i++) {
    x = (float) i / n * width + n / 2;
    for(int j = 0; j < n; j++) {
      y = (float) j / n * height + n / 2;
      for(int k = 0; k < n; k++) {
        z = (float) k / n * depth + n / 2;
        if((i ^ j) == k) {
          stroke((float) j / n * 255.0, (float) k / n * 100.0 + (float) val / 100 * 200, (float) 255 - i / n * 255.0, 100);
          PVector pt = new PVector(x + sin((float) ((i + val % n) * n * 0.05) / n * TWO_PI * 2.0) * 50.0, y + cos((float) ((i + val % n) * n * 0.05) / n * TWO_PI * 2.0) * 50.0, z);
          point(pt.x, pt.y, pt.z);
        }
      }
    }
  }
}