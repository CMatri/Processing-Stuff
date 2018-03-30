import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;
import peasy.*;
import bRigid.*;
import javax.vecmath.Vector3f;

HE_Mesh box;
WB_Render render;
PeasyCam cam;
BPhysics physics;
BBox bbox;

void setup(){
  size(1280, 720, P3D);
  frameRate(60);
  
  cam = new PeasyCam(this, 600);
  
  Vector3f min = new Vector3f(-120, -250, -120);
  Vector3f max = new Vector3f(120, 250, 120);
  
  physics = new BPhysics(min, max);
  physics.world.setGravity(new Vector3f(0, 500, 0));
  bbox = new BBox(this, 1, 15, 60, 15);
  
  HEC_Box boxCreator = new HEC_Box(); 
  boxCreator.setWidth(200).setWidthSegments(8);
  boxCreator.setHeight(20).setHeightSegments(5).setDepth(200).setDepthSegments(3);  
  boxCreator.setCenter(100,100,0).setZAxis(1,1,1).setZAngle(PI/4);
  box = new HE_Mesh(boxCreator);
  render = new WB_Render(this);
}

void draw(){
  background(120);
  lights();
  rotateY(frameCount * 0.01f);

  if(frameCount % 4 == 0) {
    Vector3f pos = new Vector3f(random(30), -150, random(1));
    BObject r = new BObject(this, 100, bbox, pos, true);
    physics.addBody(r);
  }

  physics.update();
  physics.display();
  
  //render.drawFaces(box);
  //render.drawEdges(box);
}