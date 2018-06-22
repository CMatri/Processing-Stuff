import java.util.Comparator;
import java.util.Collections;

PShader blur;
ArrayList<PVector> points = new ArrayList<PVector>();
float depth = 550;

void setup() {
  size(550, 550, P3D);
  background(0);
  frameRate(60);
  blur = loadShader("blur.glsl");
  
  for(int i = 0; i < 40; i++) {
    points.add(new PVector(random(200), random(TWO_PI), random(TWO_PI)));
  }
}

void draw() {
  pushStyle();
  fill(1, 40);
  rect(0, 0, width, height);
  popStyle();
  translate(width / 2, height / 2);
  
  for(PVector p : points) {    
    filter(blur);
    //println(frameRate);

    float r = p.x + sin(frameCount % 100 / 100.0 * TWO_PI) * 100;
    float theta = p.y;// + sin(noise(frameCount % 1000.0 / 1000.0) * PI) * 10.0;
    float phi = p.z;//   + cos(noise(frameCount % 1000.0 / 1000.0) * PI) * 10.0;
    float x = r * sin(theta) * cos(phi);
    float y = r * sin(theta) * sin(phi);
    float z = r * cos(theta);
    float w = z / depth * 15 + 10;
    stroke(z / depth / 2 * 255 + 100);
    strokeWeight(2);
    fill(z / depth / 2 * 255 + 100);
    ellipse(x, y, w, w);
  }
  
  Collections.sort(points, new Comparator<PVector>() {
    @Override
    public int compare(PVector z1, PVector z2) {
        if (z1.x * cos(z1.y) > z2.x * cos(z2.y))
            return 1;
        if (z1.x * cos(z1.y) < z2.x * cos(z2.y))
            return -1;
        return 0;
    }
  });
}