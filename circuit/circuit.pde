int nParticles = 900;
ArrayList<Particle> particles = new ArrayList<Particle>();
PVector[] dirs = { new PVector(1, 0),  new PVector(1, 1),  new PVector(1, -1), new PVector(0, 1),  new PVector(0, -1), new PVector(-1, 0), new PVector(-1, 1), new PVector(-1, -1) };

void setup() {
  size(1080, 1080);
  
  for(int i = 0; i < nParticles; i++) {
    Particle p = new Particle(new PVector(width / 2, height / 2), dirs[(int) random(0, dirs.length)]);
    particles.add(p);
  }
}

void draw() {
  background(0);
  //blendMode(ADD);
  
  stroke(255);
  fill(255);
    
  for(Particle p : particles) {
    p.update(1.0/frameRate / 0.2);
    
    if(random(0, 1) > .9) {
      if(p.vel.x < 1) {
        if(random(0, 1) > 0.5) p.
      }
      p.vel = new PVector(p.vel.x, p.vel.y);
    }
    
    ellipse(p.pos.x, p.pos.y, 5, 5);  
  }
}