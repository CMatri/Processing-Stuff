class Particle {  
  public PVector pos, vel;
  public boolean isStatic = false;
  
  public Particle(PVector origPos) {
    this(origPos, new PVector(0, 0, 0));
  }  
  
  public Particle(PVector origPos, PVector vel) {
    this.pos = origPos;
    this.vel = vel;
  }
  
  public void update(float dt) {
    if(isStatic) return;
    
    pos.x += vel.x; 
    pos.y += vel.y;
    pos.z += vel.z;
  }
}  