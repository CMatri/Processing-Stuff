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

Particle[] p;
Vector[] deltas;

float spread = 0.093;
float k = 0.008;
float d = 0.008;

int numSpreadSteps = 8;
int numParticles = 150;

int drawWater = 0;

Particle ball;

void setup() {
  size(1920, 1080, P3D);
  background(0);

  ball = new Particle(new Vector(width / 2, height / 4), new Vector(0, 3));

  p = new Spring[numParticles];
  deltas = new Vector[numParticles];
  
  for(int i = 0; i < numParticles; i++) {
    float ps = height / 2;// - 200 + 600 * (1 / (1 + (float) Math.pow(2.71828, (i - numParticles / 2 - 100) / 10.0)));//200 * -(sin((float) i / numParticles * (2 * PI) + PI / 2));
    p[i] = new Spring(new Vector((i + 0.5) * ((float) width / numParticles), ps));
    deltas[i] = new Vector(0, 0);
  }
}

void draw() {
  background(0);//102, 178, 255);
  
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
  
  /*ball.update();
  
  int index = (int) (ball.pos.x * numParticles / width);
  if(ball.pos.y >= p[index].pos.y - 10 && ball.vel.y > 0) {
    ball.vel.y = -ball.vel.y;
    for(int i = -4; i < 4; i++)
      p[index + i].vel.y += 75;
  } else if(ball.pos.y <= 10)
    ball.vel.y = -ball.vel.y;
  
  fill(0, 0, 255);
  stroke(255, 0, 0);
  ellipse(ball.pos.x, ball.pos.y, 20, 20);*/
}

void keyReleased() { drawWater += drawWater < 3 ? 1 : -drawWater; }