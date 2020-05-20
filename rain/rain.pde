class Drop {
  PVector pos;
  PVector vel;
  PVector acc;
  float radius = 6.5;
  
  public Drop(float x, float accX) {
    this.pos = new PVector(x, 0);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(accX, 9.8f);
  }
  
  public void update(float dt) {
    PVector dtAcc = PVector.div(acc, dt);
    vel.add(dtAcc);
    pos.add(vel);
    
    ellipse(pos.x, pos.y, radius, radius);
  }
}

class Agent {
  PVector pos;
  PVector dims;
  float walkSpeed;
  float aWidth, aHeight;
  ArrayList<Drop> hasCollided;
  
  public Agent(float walkSpeed) {
    this.pos = new PVector(0, height - 100);
    this.dims = new PVector(40, 100);
    this.walkSpeed = walkSpeed;
    this.hasCollided = new ArrayList<Drop>();
  }
  
  public void update(float dt) {
    if(dt > 50) return;
    pos.x += walkSpeed * dt;
    
    rect(pos.x, pos.y, dims.x, dims.y);
  }
  
  public void collide(Drop d) {
    if(hasCollided.contains(d)) return;
    
    float testX = d.pos.x;
    float testY = d.pos.y;
    
    if(d.pos.x < pos.x) testX = pos.x;
    else if(d.pos.x > pos.x + dims.x) testX = pos.x + dims.x;
    if(d.pos.y < pos.y) testY = pos.y;
    else if(d.pos.y > pos.y + dims.y) testY = pos.y + dims.y;
    
    float dX = d.pos.x - testX;
    float dY = d.pos.y - testY;
    
    if(sqrt(dX * dX + dY * dY) <= d.radius) hasCollided.add(d); 
  }
}

ArrayList<Agent> agents = new ArrayList<Agent>();
ArrayList<Drop> drops = new ArrayList<Drop>();
long prev;
long dropCounter = 0;
float dropsPerSecond = 1000;
float dt = 0;
float windSpeed = -3.6;
int numAgents = 50;
float agentMaxSpeed = 3;

void setup() {
  frameRate(60);
  size(1920, 1080, P3D);
}

void draw() {
  background(60);
  
  if(frameCount > 60 * 2 && agents.size() == 0) {
    for(int i = 0; i < numAgents; i++) {
      agents.add(new Agent((float) (i + 1) / numAgents * agentMaxSpeed));
    }
  }
  
  if((dropCounter += (dt < 50 ? dt : 0)) >= 1000f / dropsPerSecond) {
    for(float i = dropCounter; i >= 1000f / dropsPerSecond; i -= 1000f / dropsPerSecond) {
      drops.add(new Drop(random(width * 1.3) - (width * 0.3 * (windSpeed < 0 ? 0 : 1)), windSpeed));
    }
    dropCounter = 0;
  }
  
  stroke(0);
  fill(50, 160, 210);

  ArrayList<Drop> removeDrops = new ArrayList<Drop>();
  for(Drop d : drops) {
    d.update(dt);
    if(d.pos.y > height) removeDrops.add(d);
  }
  drops.removeAll(removeDrops);
  
  fill(255, 0, 0);  
  
  ArrayList<Agent> removeAgents = new ArrayList<Agent>();
  for(Agent a : agents) {
    a.update(dt);
    if(a.pos.x > width) {
      removeAgents.add(a);
      println(a.hasCollided.size());
    } else {
      for(Drop d : drops) a.collide(d);
    }
  }
  agents.removeAll(removeAgents);
  
  dt = (-prev + (prev = frameRateLastNanos)) / 1e6f;
}
