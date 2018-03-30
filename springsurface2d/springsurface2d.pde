class Spring extends Particle {
  public Spring(Vector origPos) {
    super(origPos);
  }
  
  @Override
  public void update(float... params) { // params[0] = k, params[1] = d
    float x = origPos.y - pos.y;
    vel.y += params[0] * x - vel.y * params[1];
    pos.y += vel.y;
  }
}
  
class Particle {  
  public Vector origPos, pos, vel;
  
  public Particle(Vector origPos) {
    this(origPos, new Vector(0, 0));
  }
  
  public Particle(Vector origPos, Vector vel) {
    this.origPos = origPos;
    this.pos = new Vector(origPos.x, origPos.y);
    this.vel = vel;
  }
  
  public void update(float... params) {
    pos.x += vel.x;
    pos.y += vel.y;
  }
}

class Vector {
  float x, y;

  public Vector(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

Particle[][] p;
Vector[][] deltas;

float spread = 0.09;
float k = 0.01;
float d = 0.02;

int numSpreadSteps = 2;
int numParticles = 75;
int scl = 20;
int renderMode = 0;

enum BC {DIRICHLET, NEUMANN, CONTINUOUS};
BC boundary_cond = BC.NEUMANN;

void setup() {
  size(1920, 1080, P3D);
  background(0);
  
  p = new Spring[numParticles][numParticles];
  deltas = new Vector[numParticles][numParticles];
  
  for(int y = 0; y < numParticles; y++) {
    for(int x = 0; x < numParticles; x++) {
      p[x][y] = new Spring(new Vector(0, 0));
      deltas[x][y] = new Vector(0, 0);
    }
  }
}

float pX = 0, py = 0;
long prev;

void setBnd(BC condition) {
  switch(condition) {
    case DIRICHLET:
      for(int x = 0; x < numParticles; x++) {
        p[x][0].vel = new Vector(0, 0);
        p[x][0].pos = p[x][0].origPos;
        p[x][numParticles - 1].vel = new Vector(0, 0);
        p[x][numParticles - 1].pos = p[x][0].origPos;
        
        p[0][x].vel = new Vector(0, 0);
        p[0][x].pos = p[x][0].origPos;
        p[numParticles - 1][x].vel = new Vector(0, 0);
        p[numParticles - 1][x].pos = p[x][0].origPos;
      }
      break;
    case NEUMANN:
      break;
    case CONTINUOUS:
      for(int x = 0; x < numParticles; x++) {
        p[x][0].vel = new Vector(p[x][1].vel.x, 0);
        p[x][numParticles - 1].vel = new Vector(p[x][numParticles - 2].vel.x, 0);
        
        p[0][x].vel = new Vector(0, p[1][x].vel.y);
        p[numParticles - 1][x].vel = new Vector(0, p[numParticles - 2][x].vel.y);
      }
      break;
  } 
}

void keyReleased() {
  renderMode += renderMode == 2 ? -2 : 1;
}

void draw() {
  int r = 1;
  
  if(mousePressed) {
    float xx = ((float) mouseX / width) * numParticles;
    float yy = ((float) mouseY / height) * numParticles;
    
    for(int x = -r; x <= r; x++)
      for(int y = -r; y <= r; y++)
        p[max(min(numParticles - 1, (int) xx + x), 0)][max(min(numParticles - 1, (int) yy + y), 0)].vel.y += 20;
  }
  
  for(int j = 0; j < numSpreadSteps; j++) {
    for(int x = 0; x < numParticles; x++) {
      for(int y = 0; y < numParticles; y++) {
        if(x > 0) {
          deltas[x][y].x = spread * (p[x][y].pos.y - p[x - 1][y].pos.y);
          p[x - 1][y].vel.y += deltas[x][y].x;
        }
        
        if(x < numParticles - 1) {
          deltas[x][y].y = spread * (p[x][y].pos.y - p[x + 1][y].pos.y);
          p[x + 1][y].vel.y += deltas[x][y].y;
        }
        
        if(y > 0) {
          deltas[x][y].x = spread * (p[x][y].pos.y - p[x][y - 1].pos.y);
          p[x][y - 1].vel.y += deltas[x][y].x;
        }
        
        if(y < numParticles - 1) {
          deltas[x][y].y = spread * (p[x][y].pos.y - p[x][y + 1].pos.y);
          p[x][y + 1].vel.y += deltas[x][y].y;
        }
      }
    }
    
    for(int i = 0; i < p.length; i++) {
      //if(i > 0) p[i - 1].pos += deltas[i].x;
      //if(i < p.length - 1) p[i + 1].pos += deltas[i].y;
    }
  }
  
  setBnd(boundary_cond);
 
  background(0);
  stroke(200, 200, 200, 10);
  fill(20, 20, 100, 200);
  lights();
  ambientLight(50, 50, 50);
  directionalLight(255, 255, 255, 1, 0.75, 0);
  
  translate(width / 2, height / 2);
  rotateX(-PI / 4);
  translate(-735, 100, -1080);  

  for(int y = 0; y < numParticles; y++)
    for(int x = 0; x < numParticles; x++)
      p[x][y].update(k, d);
 
  for(int y = 0; y < numParticles - 1; y++) {
    beginShape(TRIANGLE_STRIP);
    for(int x = 0; x < numParticles; x++) {
      if(renderMode == 1) {
        fill(p[x][y].vel.y * 200 / 35 + 40, 40, 40, 200);
        vertex(x * scl, p[x][y].pos.y, y * scl);
        fill(p[x][y + 1].vel.y * 200 / 35 + 40, 40, 40, 200);
        vertex(x * scl, p[x][y + 1].pos.y, (y + 1) * scl);
      } else if(renderMode == 2) {
        fill(deltas[x][y].x * 200 + 30, deltas[x][y].y * 200 + 30, (deltas[x][y].x * 200 + deltas[x][y].y * 200) / 2 + 30, 200);
        vertex(x * scl, p[x][y].pos.y, y * scl);  
        fill(deltas[x][y + 1].x * 200 + 30, deltas[x][y + 1].y * 200 + 30, (deltas[x][y + 1].x * 200 + deltas[x][y + 1].y * 200) / 2 + 30, 200);
        vertex(x * scl, p[x][y + 1].pos.y, (y + 1) * scl);
      } else {
        vertex(x * scl, p[x][y].pos.y, y * scl);  
        vertex(x * scl, p[x][y + 1].pos.y, (y + 1) * scl);
      }
    }
    endShape();
  }
}