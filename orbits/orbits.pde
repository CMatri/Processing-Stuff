import java.text.DecimalFormat;

void setup() {
  size(1080, 1080);
}

float r0 = 400;
float r1 = 200;
float t0 = 0;
float t1 = PI / 2;
float drawTimer = 0;
ArrayList<PVector[]> sets = new ArrayList<PVector[]>();

void draw() {
  background(0);
  
  scale(1, -1);
  translate(width / 2, -height + height / 2);
  
  float x0 = cos(t0) * r0;
  float y0 = sin(t0) * r0;
  float x1 = cos(t1) * r1;
  float y1 = sin(t1) * r1;
  
  t0 += t0 >= 2 * PI ? -t0 : 0.02;
  t1 += t1 >= 2 * PI ? -t1 : 0.01;
  drawTimer += .23;
  
  stroke(0, 255, 0);
  fill(255);
  line(x0, y0, x1, y1);
  stroke(255);
  ellipse(x0, y0, 15, 15);
  ellipse(x1, y1, 15, 15);
  
  for(PVector[] s : sets) {
    stroke(255);
    line(s[0].x, s[0].y, s[1].x, s[1].y);
  }

  DecimalFormat df = new DecimalFormat("#.000");
 
  if(Float.valueOf(df.format(drawTimer)) % 1 == 0)
    sets.add(new PVector[]{ new PVector(x0, y0), new PVector(x1, y1) });
}
