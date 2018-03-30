int n = 250;
int nParticles = 900;
float[][] densities = new float[n][n];
ArrayList<Particle> particles = new ArrayList<Particle>();
ArrayList<PVector> centroidHistory = new ArrayList<PVector>();
PVector centroid;

void setup() {
  size(1080, 1080);
  
  for(int i = 0; i < nParticles; i++) {
    Particle p = new Particle(new PVector(random(width * .15, width * .75), random(width * .25, height * .85)), new PVector(0, 0));
    particles.add(p);
  }
}

void draw() {
  background(0);
  blendMode(ADD);
  
  stroke(20, 100, 20, 200);
  fill(20, 100, 20, 200);
  
  centroid = new PVector(0, 0);
  
  for(Particle p : particles) {
    p.update(1.0/frameRate / 0.2);
    centroid = centroid.add(p.pos);
    densities[max(0, min(n - 1, int(p.pos.x / width * n)))][max(0, min(n - 1, int(p.pos.y / height * n)))] += 1;
    
    for(Particle p1 : particles) {
      float d = dist(p1.pos.x, p1.pos.y, p.pos.x, p.pos.y);
      float strength = .01f * min(999999, (1.0 / (d)));
      p.vel.add(new PVector((p1.pos.x - p.pos.x) * strength, (p1.pos.y - p.pos.y) * strength));
    }
    
    if(mousePressed) {
      float d = dist(mouseX, mouseY, p.pos.x, p.pos.y);
      float strength = 1f * min(5000,(1.0/(d)));
      p.vel.add(new PVector((mouseX - p.pos.x) * strength, (mouseY - p.pos.y) * strength));
    }
    
    ellipse(p.pos.x, p.pos.y, 5, 5);  
  }
  
  centroid = centroid.div(nParticles);
  centroidHistory.add(centroid);
  
  fill(255, 0, 0);
  stroke(255, 0, 0);
  
  for(int i = 1; i < centroidHistory.size(); i++)
    line(centroidHistory.get(i).x, centroidHistory.get(i).y, centroidHistory.get(i - 1).x, centroidHistory.get(i - 1).y);
  
  for(int i = 0; i < n; i++) {
    //float cX = (float) i / n * width + 0.5 / n * width;
    for(int j = 0; j < n; j++) {
      //float cY = (float) j / n * height + 0.5 / n * height;
      densities[i][j] = 0;
    }
  }
}