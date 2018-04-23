void setup() {
  size(1000, 1000);
  frameRate(60);
  stroke(255);
  fill(255);
}

void draw() {
  // y[i] -(+)= random(osc) - osc / 2.0 + (y[i] - (i > 0 && i < numPoints - 1 ? ((y[i-1] + y[i+1]) / 2.) : (i == 0 ? y[i+1] : y[i-1]))) / modulation;
}