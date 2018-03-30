void setup() {
  size(800, 800, P3D);
}

ArrayList<PVector> positions = new ArrayList<PVector>();

float x, y, z;
float t = 0;
float r = 10;
float f = 1;

void draw() {
  background(30);
  translate(width / 2, height / 4);
  rotateX(PI / 16f);// * t);

  x = cos(t) * f;
  y = t;//sin(t) * f + 5;
  z = sin(t) * f;
  t += 0.35;
  
  f = 1.0 / (1 + pow(2.718281828, -t / 100f)) * 14 + sqrt(t) * 3 + (t * t / 400);
  positions.add(new PVector(x, y, z));
  
  fill(255);
  for(int i = 1; i < positions.size(); i++) {
    stroke((float) i / positions.size() * 255, 100, 50);
    PVector a = positions.get(i - 1);
    PVector b = positions.get(i);
    line(a.x, a.y, a.z, b.x, b.y, b.z);
  }
}