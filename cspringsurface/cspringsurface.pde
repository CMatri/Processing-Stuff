class Particle {  
  public PVector origPos, pos, vel;
  
  public Particle(PVector origPos) {
    this(origPos, new PVector(0, 0));
  }
  
  public Particle(PVector origPos, PVector vel) {
    this.origPos = origPos;
    this.pos = new PVector(origPos.x, origPos.y);
    this.vel = vel;
  }
  
  public void update(float... params) {
    pos.x += vel.x;
    pos.y += vel.y;
  }
}

class Spring extends Particle {
  public Spring(PVector origPos) {
    super(origPos);
  }
  
  @Override
  public void update(float... params) { // params[0] = k, params[1] = d
    float x = origPos.y - pos.y;
    vel.y += params[0] * x - vel.y * params[1];
    pos.y += vel.y;
  }
}

class SpringSurface {
  Particle[] p;
  PVector[] deltas;
  
  float spread;
  float k;
  float d;
  
  int numSpreadSteps;
  int numParticles;
  
  int drawWater = 0;

  public SpringSurface(float[] func) {
    this(0.093, 0.008, 0.008, 8, 150, func);
  }
  
  public SpringSurface(float spread, float k, float d, int numSpreadSteps, int numParticles, float[] func) {
    this.spread = spread;
    this.k = k;
    this.d = d;
    this.numSpreadSteps = numSpreadSteps;
    this.numParticles = numParticles;
    
    p = new Spring[numParticles];
    deltas = new PVector[numParticles];
    
    for(int i = 0; i < numParticles; i++) {
      float ps = func[i];//height / 2;// - 200 + 600 * (1 / (1 + (float) Math.pow(2.71828, (i - numParticles / 2 - 100) / 10.0)));//200 * -(sin((float) i / numParticles * (2 * PI) + PI / 2));
      p[i] = new Spring(new PVector((i + 0.5) * ((float) width / numParticles), ps));
      deltas[i] = new PVector(0, 0);
    }
  }
  
  public void update() {
    for(int j = 0; j < numSpreadSteps; j++) {
      for(int i = 0; i < numParticles; i++) {
        if(i > 0) {
          deltas[i].x = spread * (p[i].pos.y - p[i - 1].pos.y);
          p[i - 1].vel.y += deltas[i].x;
        }
        
        if(i < p.length - 1) {
          deltas[i].y = spread * (p[i].pos.y - p[i + 1].pos.y);
          p[i + 1].vel.y += deltas[i].y;
        }
      }
      
      for(int i = 0; i < p.length; i++) {
        //if(i > 0) p[i - 1].pos += deltas[i].x;
        //if(i < p.length - 1) p[i + 1].pos += deltas[i].y;
      }
    }
  
    if(mousePressed)
      for(int i = -0; i <= 1; i++)
        p[i + (int) ((float) numParticles / width * mouseX)].vel.y += 9;
    
    for(int i = 0; i < numParticles; i++) {
      p[i].update(k, d);
    }
    
    float div = ((float) width / numParticles);
      
    if(drawWater == 0) {
      noStroke();  
      beginShape(QUAD_STRIP);
      for(int i = 0; i < numParticles; i++) {
        fill(51 / 6, 153 / 6, 255 / 6);
        vertex((i + 0.5) * div, height);
        fill(51, 153, 255);
        vertex(p[i].pos.x, p[i].pos.y);
      }
      endShape();
    } else if(drawWater == 1) {
      stroke(255);
      noFill();
      for(int i = 0; i < numParticles; i++) {
        line(p[i].pos.x, p[i].pos.y + div - 5, (i + 0.5) * div, height);
        ellipse(p[i].pos.x, p[i].pos.y, div, div);
      }
    } else if(drawWater == 2) {
      noStroke();
      beginShape(QUAD_STRIP);
      for(int i = 0; i < numParticles; i++) {
        fill(p[i].vel.y / 10.0 * 255 + 75);
        vertex(p[i].pos.x, height);
        vertex(p[i].pos.x, p[i].pos.y);
      }
      endShape();
    } else if(drawWater == 3) {
      noStroke();
      beginShape(QUAD_STRIP);
      for(int i = 0; i < numParticles; i++) {
        fill(Math.abs((deltas[i].x + deltas[i].y) / 1.0) * 255, Math.abs(deltas[i].x / 1.0) * 255, Math.abs(deltas[i].y / 1.0) * 255);
        vertex(p[i].pos.x, height);
        vertex(p[i].pos.x, p[i].pos.y);
      }
      endShape();
    }
  }
}