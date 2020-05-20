float frequency = 5; // beats per second
float cyclesPerSecond = 0;
float cyclesPerSecondRange = frequency * 2;


class FourierData {
  static final float deltaT = 0.01f;
  float timeLength;
  float cyclesPerSecond;
  float frequency;
  PVector massPoint;
  PVector[] circleTransforms;
  
  public FourierData(float timeLength, float cyclesPerSecond, float frequency) {
    this.timeLength = timeLength;
    this.cyclesPerSecond = cyclesPerSecond;
    this.frequency = frequency;
  }
  
  public void calculateSpectrum() {
    float lastX = getIntensity(0);
    float lastY = 0;
    float avgX = 0;
    float avgY = 0;
    float dA = 0;
    ArrayList<PVector> points = new ArrayList<PVector>();
    for(float t = 0; t < timeLength; t += deltaT) {
      float intensity = getIntensity(t);
      float x = cos(t / cyclesPerSecond * TWO_PI) * intensity;
      float y = sin(t / cyclesPerSecond * TWO_PI) * intensity;
      points.add(new PVector(lastX, lastY));
      lastX = x;
      lastY = y;
      avgX += x;
      avgY += y;
      dA++;
    }
    
    avgX /= dA;
    avgY /= dA;
    
    massPoint = new PVector(avgX, avgY);
    circleTransforms = points.toArray(new PVector[points.size()]);
  }
}

float getIntensity(float t) {
  return (cos(t / frequency * TWO_PI) / 2 + 0.5) + (cos(t / (frequency - 3) * TWO_PI) / 2 + 0.5);// - (sin(t / (frequency + 3) * TWO_PI) / 2 + 0.5); // two major frequencies
}


FourierData fData;

void setup() {
  size(1200, 1200);
  background(0);
  
  
  fData = new FourierData(20, cyclesPerSecond, frequency);
}

void draw() {
  background(0);
  stroke(255);
  fill(255);
  
  cyclesPerSecond = (float) mouseY / height * cyclesPerSecondRange;
  textSize(40);
  text(cyclesPerSecond, 10, 40);
  
  pushMatrix();
  translate(width / 2, height / 2);
  fData.cyclesPerSecond = cyclesPerSecond;
  fData.calculateSpectrum();
  text(fData.circleTransforms[1].x, 10, 80);
  
  float drawRadius = 200;
  float lastX = fData.circleTransforms[0].x;
  float lastY = fData.circleTransforms[0].y;
  for(int i = 0; i < fData.circleTransforms.length; i++) {
    line(fData.circleTransforms[i].x * drawRadius, fData.circleTransforms[i].y * drawRadius, lastX * drawRadius, lastY * drawRadius);
    lastX = fData.circleTransforms[i].x;
    lastY = fData.circleTransforms[i].y;
  }
  
  ellipse(fData.massPoint.x * drawRadius, fData.massPoint.y * drawRadius, 10, 10);
  popMatrix();
  
  lastX = 0;
  lastY = 3f / 4f * height;
  for(float c = 0; c < cyclesPerSecondRange; c += 0.1f) {
    fData.cyclesPerSecond = c;
    fData.calculateSpectrum();

    float fourierComponent = fData.massPoint.x * 200;
    float x = c / cyclesPerSecondRange * width;
    float y = (3f / 4f * height) + fourierComponent;
    
    stroke(255, abs(fData.massPoint.y) * 2000, 0);
    fill(255, abs(fData.massPoint.y) * 2000, 0);
    line(x, y, lastX, lastY);
    lastX = x;
    lastY = y;
    
    if(abs(((float) x / width) - ((float) mouseY / height)) < 0.03) {
      stroke(0, 255, 0);
      fill(0, 255, 0);
      ellipse(x, y, 10, 10);
    }
  }
}