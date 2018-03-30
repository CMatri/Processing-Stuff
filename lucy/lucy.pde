float[] h, p;
float x, x2, y, y2, a, b_radius, timer, risePoint, colY, opacity = 0;
boolean hasRisen, testing = false;

void setup() {
  size(800, 800, P2D);
  frameRate(60);
  textFont(createFont(PFont.list()[15], 34));
  
  risePoint = 800;
  h = new float[200];
  p = new float[200];
  a = 1.0 / h.length * width;
  timer = 0;
  colY = 300;
  
  for(int i = 0; i < h.length; i++)
    h[i] = 295;
  for(int i = 0; i < p.length; i++)
    p[i] = pow(i * 0.8 - p.length / 2, 2) + 500;
}

void draw() {
  if(hasRisen) background((sin(timer % 250 / 250 * 2 * PI) + 1) / 2.0 * 200 + 27.5, (sin(timer % 300 / 300 * 2 * PI) + 1) / 2.0 * 150 + 50, 255 - (sin(timer % 200 / 200 * 2 * PI) + 1) / 2.0 * 255);
  else background(100);
  
  translate(0, 280);
  fill(255);
  strokeWeight(5);
  timer++;
  
  for(int i = 0; i < h.length; i++) {
    x = i * a;
    x2 = i * a + timer - 400;
    y = h[i];
    y2 = p[i];
    
    if(!hasRisen) stroke(0, abs(y - (colY - 10)) / 20.0 * 255, abs(y - colY) / 40.0 * 120);
    else stroke(255 - (sin(timer % 200 / 200 * 2 * PI) + 1) / 2.0 * 200 + 20, 255 - (sin(timer % 400 / 400 * 2 * PI) + 1) / 2.0 * 200 + 27.5, 255 - (sin(timer % 250 / 250 * 2 * PI) + 1) / 2.0 * 200 + 40);
    
    line(x - a, (i < 1 ? h[i] : h[i - 1]), x, y);
    //line(x2 - a, (i < 1 ? p[i] : p[i - 1]), x2, y2);
    p[i] += (x2 - 400) * 0.0055;
    
    if(timer > risePoint || testing) {
      if(y > 100 && !hasRisen) {
        h[i] -= 2;
      } else hasRisen = true;
      
      if(hasRisen || testing) {
        float modulation = 0.55 + 1.0 - (sin(timer % 150 / 150 * 2 * PI) + 1) / 1.92;
        float osc = 20;
        h[i] -= random(osc) - osc / 2. + (h[i] - (i > 0 && i < h.length - 1 ? ((h[i-1] + h[i+1]) / 2.) : (i == 0 ? h[i+1] : h[i-1]))) / modulation;//sin(timer % 100 / 100 * PI) * 5;
      }
    }
    
    if(!hasRisen && y < 295 && y > 110) h[i] += abs(h[i] - 300) * 0.01;
    
    for(int j = 0; j < h.length; j++)
      if(j * a == x2 && h[j] > p[i]) h[j] = p[i];  
  }
  
  println((timer > risePoint && timer < risePoint + 200), timer, risePoint, opacity);
  
  if(timer < 200 || (timer > risePoint && timer < risePoint + 200)) {
    textSize(40);
    fill(255, 255, 255, opacity);
    
    if(timer < 200) text("WEED", width / 2 - 80, 20);
    else text("LSD", width / 2 - 80, 20);
    if((timer < 100 || timer > risePoint && timer < risePoint + 100) && opacity < 290) opacity += 3;
    else opacity -= 5;
  } else opacity = 0;
}