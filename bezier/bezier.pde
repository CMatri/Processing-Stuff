import queasycam.*;

PVector p0, p1, p2, p3, p4, p5;
PVector a0, a1, aMid;
PVector[] verts3;
ArrayList<PVector> surf;
float a = 0;
float b = 0;
QueasyCam cam;

void setup() {
  size(3840, 2160, P3D);
  background(0);
  
  cam = new QueasyCam(this);
  cam.speed = 2;
  cam.sensitivity = 0.5;  
  
  p0 = new PVector(0, height / 2);
  p1 = new PVector(width / 5f, 0);
  p2 = new PVector(width * (2f / 5f), height / 2);
  p3 = new PVector(width * (3f / 5f), height / 2);
  p4 = new PVector(width * (4f / 5f), 0);
  p5 = new PVector(width, height / 2);
  a0 = new PVector(0, height / 2);
  a1 = new PVector(0, height / 2);
  aMid = new PVector(0, height / 2);
  surf = new ArrayList<PVector>();
  
  verts3 = quintBezier(p0, p1, p2, p3, p4, p5, 0.02);
  surf = makeSurface(verts3);
}

PVector[] quadBezier(PVector p0, PVector p1, PVector p2, float dt) {
  PVector[] res = new PVector[(int) (1.0f / dt)];
  
  for(float i = 0; i < res.length; i++) {
    float t = i / res.length;
    float x = (1 - t) * (1 - t) * p0.x + (1 - t) * 2 * t * p1.x + t * t * p2.x;
    float y = (1 - t) * (1 - t) * p0.y + (1 - t) * 2 * t * p1.y + t * t * p2.y;
    res[(int) i] = new PVector(x, y);
  }
  
  return res;
}

PVector[] cubicBezier(PVector p0, PVector p1, PVector p2, PVector p3, float dt) {
  PVector[] res = new PVector[(int) (1.0f / dt)];
  
  for(float i = 0; i < res.length; i++) {
    float t = i / res.length;
    float x = (1 - t) * (1 - t) * (1 - t) * p0.x + (1 - t) * (1 - t) * 3 * t * p1.x + (1 - t) * 3 * t * t * p2.x + t * t * t * p3.x;
    float y = (1 - t) * (1 - t) * (1 - t) * p0.y + (1 - t) * (1 - t) * 3 * t * p1.y + (1 - t) * 3 * t * t * p2.y + t * t * t * p3.y;
    res[(int) i] = new PVector(x, y);
  }
  
  return res;  
}

PVector[] quintBezier(PVector p0, PVector p1, PVector p2, PVector p3, PVector p4, PVector p5, float dt) {
  PVector[] res = new PVector[(int) (1.0f / dt)];
  
  for(float i = 0; i < res.length; i++) {
    float t = i / res.length;
    float x = pow(1 - t, 5) * p0.x + 5 * t * pow(1 - t, 4) * p1.x + 10 * pow(t, 2) * pow(1 - t, 3) * p2.x +
              10 * pow(t, 3) * pow(1 - t, 2) * p3.x + 5 * pow(t, 4) * (1 - t) * p4.x + pow(t, 5) * p5.x;
    float y = pow(1 - t, 5) * p0.y + 5 * t * pow(1 - t, 4) * p1.y + 10 * pow(t, 2) * pow(1 - t, 3) * p2.y +
              10 * pow(t, 3) * pow(1 - t, 2) * p3.y + 5 * pow(t, 4) * (1 - t) * p4.y + pow(t, 5) * p5.y;
    res[(int) i] = new PVector(x, y);
  }
  
  return res;
}

ArrayList<PVector> makeSurface(PVector[] verts) {
  PVector[] fullVerts = new PVector[verts.length * 2];
  for(int i = 0; i < fullVerts.length; i++) {
    int j = i < verts.length ? i : verts.length - abs(verts.length - i) - 1;
    fullVerts[i] = new PVector(verts[j].x, i < verts.length ? verts[j].y : height - verts[j].y, verts[j].z);
  }
  
  ArrayList<PVector> s = new ArrayList<PVector>();
  for(int i = 0; i < fullVerts.length; i++) {
    PVector p0 = new PVector(fullVerts[i].x, fullVerts[i].y);
    for(int j = 0; j < fullVerts.length; j++) {
      PVector p1 = new PVector(fullVerts[j].x, fullVerts[j].y);
      PVector pMid = new PVector(abs(p0.x + p1.x) / 2, abs(p0.y + p1.y) / 2, dist(p0.x, p0.y, p1.x, p1.y) / 2);
      s.add(pMid);
    }
  }
  
  return s;
}

void draw() {
  background(0);
    
  fill(255);
  stroke(255);
  scale(0.1);
  rotateX(PI / 2f);

  ellipse(p0.x, p0.y, 15, 15);
  ellipse(p1.x, p1.y, 15, 15);
  ellipse(p2.x, p2.y, 15, 15);
  ellipse(p3.x, p3.y, 15, 15);
  ellipse(p4.x, p4.y, 15, 15);
  ellipse(p5.x, p5.y, 15, 15);
  
  if(mousePressed) {
    p1 = new PVector(p1.x, p1.y + (mouseButton == 37 ? -13 : 13));
    p4 = new PVector(p4.x, p4.y + (mouseButton == 37 ? -13 : 13));
  }
  
  fill(0, 255, 0);
  stroke(0, 255, 0);
  ellipse(a0.x, a0.y, 15, 15);
  ellipse(a1.x, a1.y, 15, 15);
  line(a0.x, a0.y, a1.x, a1.y);
  stroke(255, 0, 0);
  ellipse(aMid.x, aMid.y, 35, 35);
  line(aMid.x, aMid.y, 0, aMid.x, aMid.y, dist(a0.x, a0.y, a1.x, a1.y) / 2);
  pushMatrix();
  translate(aMid.x, aMid.y, dist(a0.x, a0.y, a1.x, a1.y) / 2f);
  sphere(15);
  popMatrix();
  
  fill(255);
  stroke(255, 0, 0);
  strokeWeight(50);
  
  /*PVector[] verts = quadBezier(p0, p1, p2, 0.01);
  for(int i = 1; i < verts.length; i++)
    line(verts[i - 1].x, verts[i - 1].y, verts[i].x, verts[i].y);
  line(verts[verts.length - 1].x, verts[verts.length - 1].y, p2.x, p2.y);

  PVector[] verts2 = cubicBezier(p0, p1, p2, p3, 0.01);
  for(int i = 1; i < verts2.length; i++)
    line(verts2[i - 1].x, verts2[i - 1].y, verts2[i].x, verts2[i].y);
  line(verts2[verts2.length - 1].x, verts2[verts2.length - 1].y, p3.x, p3.y);
  */
  
  for(int i = 1; i < verts3.length; i++) {
    line(verts3[i - 1].x, verts3[i - 1].y, verts3[i].x, verts3[i].y);
    line(verts3[i - 1].x, height - verts3[i - 1].y, verts3[i].x, height - verts3[i].y);
  }
  line(verts3[verts3.length - 1].x, verts3[verts3.length - 1].y, p5.x, p5.y);
  line(verts3[verts3.length - 1].x, height - verts3[verts3.length - 1].y, p5.x, height - p5.y);
  
  float dt = 1.1;
  if(a + dt < verts3.length * 2) a += dt;
  else {
    a = 0;    
    if(b + dt < verts3.length * 2) b += dt; 
    else b = 0;
  }
  
  int aI = (int) abs(verts3.length - a - 1);
  int bI = (int) abs(verts3.length - b - 1);
  
  a0 = new PVector(verts3[aI].x, a > verts3.length ? height - verts3[aI].y : verts3[aI].y);
  a1 = new PVector(verts3[bI].x, b > verts3.length ? height - verts3[bI].y : verts3[bI].y);
  aMid = new PVector(abs(a0.x + a1.x) / 2, abs(a0.y + a1.y) / 2);
  
  //surf = makeSurface(verts3);
  float ceil = 0;
  for(PVector p : surf) if(ceil < p.z) ceil = p.z;
  for(int i = 1; i < surf.size(); i++) {
    PVector p0 = surf.get(i);
    PVector p1 = surf.get(i - 1);
    stroke(p0.z / ceil * 255f, ((ceil - p0.z) / (ceil * 2)) * 255, ((ceil - p0.z) / ceil) * 255, 100);
    line(p0.x, p0.y, p0.z, p1.x, p1.y, p1.z);
    stroke(0, (ceil - p0.z / ceil) * 255f, p0.z / ceil * 255f, 60);
    line(p0.x, p0.y, 0, p1.x, p1.y, 0); 
  }
}

void mouseDragged() {
  if(abs(mouseX - p0.x) < 30 && abs(mouseY - p0.y) < 30) p0 = new PVector(mouseX, height / 2);
  if(abs(mouseX - p1.x) < 30 && abs(mouseY - p1.y) < 30) p1 = new PVector(mouseX, mouseY);
  if(abs(mouseX - p2.x) < 30 && abs(mouseY - p2.y) < 30) p2 = new PVector(mouseX, mouseY);
  if(abs(mouseX - p3.x) < 30 && abs(mouseY - p3.y) < 30) p3 = new PVector(mouseX, mouseY);
  if(abs(mouseX - p4.x) < 30 && abs(mouseY - p4.y) < 30) p4 = new PVector(mouseX, mouseY);
  if(abs(mouseX - p5.x) < 30 && abs(mouseY - p5.y) < 30) p5 = new PVector(mouseX, height / 2);
}