class Particle {  
  public PVector origPos, pos, vel;
  public boolean isStatic = false;
  public float weight, invWeight;
  private PVector prevPos, tempPos;
  
  public Particle(PVector origPos) {
    this(origPos, new PVector(0, 0));
  }
  
  public Particle(PVector origPos, PVector vel) {
    this(origPos, vel, 1);
  }
  
  public Particle(PVector origPos, PVector vel, float weight) {
    this.origPos = origPos;
    this.pos = new PVector(origPos.x, origPos.y);
    this.vel = vel;
    this.weight = weight;
    this.invWeight = 1f / weight;
    this.prevPos = new PVector(pos.x, pos.y);
  }
  
  public void update() {
    if(isStatic) return;
    
    tempPos = new PVector(pos.x, pos.y);
    float dx = pos.x - prevPos.x + vel.x * weight * dt;
    float dy = pos.y - prevPos.y + vel.y * weight * dt;
    
    //float vdist = sqrt(pow(pos.x+dx - obsX, 2) + pow(pos.y+dy - obsY, 2));
    //if(vdist > obsSize && pos.y+dy < height - 20) {
      pos.x += dx; 
      pos.y += dy;
    //}
    
    prevPos = tempPos;
    vel.x = 0;
    vel.y = 0;
  }
}

class Constraint {
  Particle p0, p1;
  float origLen, len;

  public Constraint(Particle p0, Particle p1, float origLen) {
    this.p0 = p0;
    this.p1 = p1;
    this.origLen = origLen;
  }
  
  public void update() {
    float distX = p1.pos.x - p0.pos.x;
    float distY = p1.pos.y - p0.pos.y;
    float dist = (float) Math.sqrt(distX * distX + distY * distY)+0.000001;
    float diff = dist - origLen;
    float resistance = 0.74;
    float transX = diff / (dist * (p0.invWeight + p1.invWeight)) * resistance * distX;
    float transY = diff / (dist * (p0.invWeight + p1.invWeight)) * resistance * distY;

    if(!p0.isStatic) {
      p0.pos.x += transX * p0.invWeight;
      p0.pos.y += transY * p0.invWeight;
    }
    
    if(!p1.isStatic) {
      p1.pos.x -= transX * p1.invWeight;
      p1.pos.y -= transY * p1.invWeight;
    }
  }
  
  public void render() {
    fill(255);
    stroke(255);
    line(p0.pos.x, p0.pos.y, p1.pos.x, p1.pos.y);
    //ellipse(p0.pos.x, p0.pos.y, 10, 10);
    //ellipse(p1.pos.x, p1.pos.y, 10, 10);
  }
}

Particle[][] p;
ArrayList<Constraint> c;

final int gw = 40;
final int gh = 20;
final float dt = 1;

float obsX = 400;
float obsY = 800;
float obsSize = 80;

void setup() {
  size(1080, 1080, P3D);
  background(60);

  p = new Particle[gw][gh];
  c = new ArrayList<Constraint>();
  
  for(int i = 0; i < gw; i++) {
    for(int j = 0; j < gh; j++)
      p[i][j] = new Particle(new PVector(200 + i * 10, 200 + j * 10), new PVector(0, 0), 1);
    p[i][0].isStatic = true;
  }

  p[0][0].isStatic = p[gw - 1][0].isStatic = true;

  float oLen = 10;
  
  for(int i = 0; i < gw; i++) {
    for(int j = 0; j < gh; j++) {
      if(j < gh - 1)
        c.add(new Constraint(p[i][j], p[i][j + 1], oLen));
      if(i < gw - 1)
        c.add(new Constraint(p[i][j], p[i + 1][j], oLen));
     // if(j < gh - 2 && j % 2 == 0)
     //   c.add(new Constraint(p[i][j], p[i][j + 2], oLen));
     // if(i < gw - 2 && i % 2 == 0)
     //   c.add(new Constraint(p[i][j], p[i + 2][j], oLen));
      if(j < gh - 1 && i < gw - 1)
        c.add(new Constraint(p[i][j], p[i + 1][j + 1], sqrt(oLen * oLen * 2)));
      if(j < gh - 1 && i > 0)
        c.add(new Constraint(p[i][j], p[i - 1][j + 1], sqrt(oLen * oLen * 2)));
    }
  }
}

void draw() {
  background(60);
  ellipse(obsX, obsY, obsSize, obsSize);
  
  for(Constraint c0 : c) {
    c0.update();
  }

  for(int i = 0; i < gw; i++) {
    for(int j = 0; j < gh; j++) {
        p[i][j].update();
        p[i][j].vel.y += 0.98f * dt;
        
        if(abs(mouseX - p[i][j].pos.x) < 30 && abs(mouseY - p[i][j].pos.y) < 30 && mousePressed) {
          p[i][j].vel.x += (mouseX - pmouseX) * 2.0;
          p[i][j].vel.y += (mouseY - pmouseY) * 2.0;
        }
    }
  }
  
  for(Constraint c0 : c) {
    c0.render();
  }
}