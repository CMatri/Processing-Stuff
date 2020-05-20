//fireworks - born of insomnia
//Firework[] fs = new Firework[10];
boolean once;
ArrayList<Firework> fs = new ArrayList<Firework>();
ArrayList<Firework> removeQueue = new ArrayList<Firework>();

void setup(){
  fullScreen(P3D);
  smooth();
  PFont font = createFont("bdayfont.ttf", 60);
  textFont(font);
}

void draw(){
  noStroke();
  fill(0x00, 0x20, 0xC2, 20);
  rect(0, 0, width, height);
  
  if(frameCount % 20 == 0) {
    Firework f = new Firework();
    f.launch();
    fs.add(f);
  }
  
  for (Firework ff : fs){
    if(!ff.draw()) removeQueue.add(ff);
  }
  
  fs.removeAll(removeQueue);
  removeQueue.clear();
  
  pushMatrix();
  fill(255);
  translate(width / 2, height / 2);
  rotate(sin(frameCount % 400.0 / 400.0 * TWO_PI) * TWO_PI / 24.0);
  textAlign(CENTER);
  textSize(120 + sin(frameCount % 200.0 / 200.0 * TWO_PI) * 30);
  text("HAPPY BIRTHDAY SCOTT", 0, 0);
  popMatrix();
}

class Firework{
  float x, y, oldX,oldY, ySpeed, targetX, targetY, explodeTimer, flareWeight, flareAngle;
  int flareAmount, duration;
  boolean launched, exploded;
  color flare;
  
  Firework(){
    launched = true;
    exploded = false;
  }
  
  boolean draw(){
    if(launched && !exploded){
      launchMaths();
      strokeWeight(3);
      stroke(255);
      line(x, y, oldX, oldY);
    }
    
    if(!launched && exploded){
      explodeMaths();
      noStroke();
      strokeWeight(flareWeight);
      stroke(flare);
      for(int i = 0; i < flareAmount + 1; i++){
          pushMatrix();
          translate(x,y);
          point(sin(radians(i * flareAngle)) * explodeTimer, cos(radians(i * flareAngle)) * explodeTimer);
          popMatrix();
       }
    }
    
    return launched || exploded;
  }
  
  void launch(){
    x = oldX = random(width);
    y = oldY = height;
    targetX = x;
    targetY = random(height / 2.5 + height / 10);
    ySpeed = random(5) + 3;
    flare = color(random(3) * 50 + 105, random(3) * 50 + 105, random(3) * 50 + 105);
    flareAmount = ceil(random(30)) + 20;
    flareWeight = ceil(random(3));
    duration = ceil(random(4)) * 20 + 80;
    flareAngle = 360 / flareAmount;
    launched = true;
    exploded = false;
  }
  
  void launchMaths(){
    oldX = x;
    oldY = y;
    if(dist(x, y, targetX, targetY) > 6){
      x += (targetX - x)/2;
      y += -ySpeed;
    } else {
      explode();
    }
  }
  
  void explode(){
    explodeTimer = 0;
    launched = false;
    exploded = true;
  }
  
  void explodeMaths(){
    if(explodeTimer < duration) {
      explodeTimer += 1.8;
    } else {
      hide();
    }
  }
  
  void hide(){
    launched = false;
    exploded = false;
  }
}