class Particle {  
  public PVector origPos, pos, vel;
  public boolean isStatic = false;
  public float weight, invWeight;
  private PVector prevPos, tempPos;
  
  public Particle(PVector origPos) {
    this(origPos, new PVector(0, 0, 0));
  }  
  
  public Particle(PVector origPos, PVector vel) {
    this(origPos, vel, 1);
  }
  
  public Particle(PVector origPos, PVector vel, float weight) {
    this.origPos = origPos;
    this.pos = new PVector(origPos.x, origPos.y, origPos.z);
    this.vel = vel;
    this.weight = weight;
    this.invWeight = 1f / weight;
    this.prevPos = new PVector(pos.x, pos.y, pos.z);
  }

  
  public void update(float dt) {
    if(isStatic) return;
    
    tempPos = new PVector(pos.x, pos.y, pos.z);
    float dx = pos.x - prevPos.x + vel.x * weight * dt;
    float dy = pos.y - prevPos.y + vel.y * weight * dt;
    float dz = pos.z - prevPos.z + vel.z * weight * dt;
    
    pos.x += dx; 
    pos.y += dy;
    pos.z += dz;
    prevPos = tempPos;
    vel = new PVector(0, 0, 0);
  }
}