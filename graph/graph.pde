// Graphing library written by Connor Perkins (8/16/18)
// The API is function (mathematical function) based in that the graph bounds are defined first and then the functions are added by their respective types, all extending from the abstract base class Function.
// 

class GraphProperties {
  public float xMax, xMin, yMax, yMin, zMax, zMin, tMax, tMin, scaleX, scaleY, scaleZ, scaleT;
   public GraphProperties(float xMax, float xMin, float yMax, float yMin, float zMax, float zMin, float tMax, float tMin, float scaleX, float scaleY, float scaleZ, float scaleT) {
    this.xMax = xMax;
    this.xMin = xMin;
    this.yMax = yMax;
    this.yMin = yMin;
    this.zMax = zMax;
    this.zMin = zMin;
    this.tMax = tMax;
    this.tMin = tMin;
    this.scaleX = scaleX;
    this.scaleY = scaleY;
    this.scaleZ = scaleZ;
    this.scaleT = scaleT;
    
    if(scaleX % 2 + scaleY % 2 + scaleZ % 2 > 0) {
      println("Scale variables need to be even.");
      exit();
    }
  }
}

class Graph {  
  private GraphProperties p;  
  private ArrayList<Function> functions;
  public Vector translation;
  public Vector fillColor;
  public Vector strokeColor;

  public Graph(GraphProperties p) {
    this.p = p;
    this.translation = new Vector(0, 0);
    this.fillColor = new Vector(255, 255, 255);
    this.strokeColor = new Vector(255, 255, 255);
    this.functions = new ArrayList<Function>();
  }
  
  public GraphProperties getProperties() {
    return p;
  }
  
  public void render() {
    //println(frameRate);
    translate(translation.x, translation.y);
    rotate(PI);
    fill(fillColor.x, fillColor.y, fillColor.z);
    stroke(strokeColor.x, strokeColor.y, strokeColor.z);
    
    float xIter = abs(p.xMax - p.xMin) / p.scaleX;
    float yIter = abs(p.yMax - p.yMin) / p.scaleY;
    
    for(float x = p.xMin; x < p.xMax; x += xIter) {
      line(x, p.yMin, x, p.yMax);
      text(x / (abs(p.xMin - p.xMax) / 2.0) * p.scaleX, x, 0);
    }
    
    for(float y = p.yMin; y < p.yMax; y += yIter)
      line(p.xMin, y, p.xMax, y);
      
   for(Function f : functions) {
      float lastX = p.xMin;   
      float lastY = 0;
      
      for(float x = p.xMin; x < p.xMax; x += abs(p.xMin - p.xMax) / 100f) {
        float y = f.calculate(x / (abs(p.xMin - p.xMax) / 2.0) * p.scaleX, p);
        ellipse(x, y / p.scaleY * abs(y < 0 ? p.yMin : p.yMax), 10, 10);
        
        lastX = x;
        lastY = y;
      }
    }
  }
  
  public void addFunction(Function f) {
    functions.add(f);
  }
}

class Vector { public float x, y, z; public Vector(float x, float y, float z) { this.x = x; this.y = y; this.z = z; } public Vector(float x, float y) { this(x, y, 0); } }

abstract class Function {
  public abstract float calculate(float x, GraphProperties p);
}

abstract class Function2D extends Function {
  public abstract float calculate(float x);
  public float calculate(float x, GraphProperties p) { return calculate(x); }
}

abstract class Function3D extends Function {
  public abstract float calculate(float x, float z);
  public float calculate(float x, GraphProperties p) { return calculate(x, 0); }
}

abstract class FunctionTemporal extends Function3D { // stand in for differential function until I research computational discretization algorithms
  public abstract float calculate(float x, float t);
  public float calculate(float x, GraphProperties p) { 
    float t = frameCount / p.scaleT;
    return calculate(x, t);
  }
}

Graph p;

void setup() {
  size(1200, 1200, P3D);
  frameRate(60.0);
  background(110, 110, 120);
  
  p = new Graph(new GraphProperties(width / 2, -width / 2, height / 2, -height / 2, height / 2, -height / 2, 1, -1, 6, 6, 6, 6));
    
 /* p.addFunction(new Function2D() {
    public float calculate(float x) {
      float y = sin(x);
      return y;
    }
  });
  
  p.addFunction(new Function2D() {
    public float calculate(float x) {
      float y = cos(x);
      return y;
    }
  });*/
  
  p.addFunction(new FunctionTemporal() {
    public float calculate(float x, float t) {
      float y = sin(t % 100.0 / 100.0 * TWO_PI / x);
      return y;
    }
  });
}

void draw() {
  background(110, 100, 120);
  
  p.translation.x = width / 2;
  p.translation.y = height / 2;
  p.render();   
}