
import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.fluid.DwFluid2D;
import com.thomasdiewald.pixelflow.java.fluid.DwFluidStreamLines2D;

DwFluid2D fluid;
DwFluidStreamLines2D streamlines;
PGraphics2D pg_fluid;
PGraphics2D pg_obstacles;

public void setup() {
  size(800, 800, P2D);

  DwPixelFlow context = new DwPixelFlow(this);
  
  streamlines = new DwFluidStreamLines2D(context);

  fluid = new DwFluid2D(context, width, height, 1);
  fluid.param.dissipation_velocity = 0.90f;
  fluid.param.dissipation_density  = 0.99f;

  fluid.addCallback_FluiData(new  DwFluid2D.FluidData() {
    public void update(DwFluid2D fluid) {
      float px     = mouseX;
      float py     = height-mouseY;
      float vx     = (mouseX - pmouseX) * 15;
      float vy     = (mouseY - pmouseY) * -15;
      fluid.addVelocity(px, py, 14, vx, vy);
      fluid.addDensity (px, py, 30, 0.3f, 0.85f, 0.15f, 1.0f);
      fluid.addDensity (px, py, 8, 1.0f, 1.0f, 1.0f, 1.0f);
    }
  });

  pg_fluid = (PGraphics2D) createGraphics(width, height, P2D);
  
  pg_obstacles = (PGraphics2D) createGraphics(width, height, P2D);
  pg_obstacles.smooth(4);
}

float posX = 400;
float posY = 400;
float dx = 1;

public void obstaclesDraw(float[] velocities) {
  float avg_velX = 0;
  float avg_velY = 0;
  float count = 0;
  float scale = 0.5;
  
  for(int x = 0; x < 25; x++) {
    for(int y = 0; y < 25; y++) {      
      int idx = int(height * (height - posY + y) + posX + x);
      avg_velX += velocities[idx * 2] * 2;
      avg_velY += -velocities[idx * 2 + 1] * 2;
      count++;
    }
  }
  
  posX += avg_velX / count * scale;
  posY += avg_velY / count * scale;
  
  pg_obstacles.beginDraw();
  pg_obstacles.clear();
  pg_obstacles.fill(64);
  pg_obstacles.noStroke();
  //pg_obstacles.ellipse(posX, posY, 25, 25);
  pg_obstacles.rect(posX, posY, 25, 25);
  pg_obstacles.endDraw(); 
}
float[] fluidMapSection;
public void draw() {
  //fluid.addObstacles(pg_obstacles);
  fluid.update();
  
  fluidMapSection= fluid.getVelocity(fluidMapSection);
  obstaclesDraw(fluidMapSection);
  
  pg_fluid.beginDraw();
  pg_fluid.background(200);
  pg_fluid.endDraw();
  //streamlines.render(pg_fluid, fluid, 5);
  fluid.renderFluidTextures(pg_fluid, 0);
  //fluid.renderFluidVectors(pg_fluid, 20);
  
  image(pg_fluid, 0, 0);
  image(pg_obstacles, 0, 0);
}