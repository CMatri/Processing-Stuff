final float zenith = 1.58533;
float t = 0;

public float solar_dec(int N) {
  return acos(0.39795*cos(0.98563*(N - 173)));
}

public float[] day_len(float lat) {
  float[] days = new float[364];
  for(int i = 0; i < days.length; i++) {
    days[i] = 2.0 * ha_sunrise(solar_dec(i), lat) / 15.0;
  }
  return days;
}

public float ha_sunrise(float solar_dec, float lat) {
  return acos(cos(zenith) / (cos(lat) * cos(solar_dec)) - tan(lat) * tan(solar_dec));
}

public void draw() {
  background(0);
  stroke(255);
  fill(255);
  //translate(width / 2, height / 2, -50);
  //sphere(20);
  int start_X = width / 8;
  int end_X = width - start_X * 2;
  t += t < 90 ? 1 : -t;
  float[] vals = day_len(t);
  
  for(int i = 0; i < vals.length; i++) {
    float x = i / (float) vals.length * end_X + start_X;
    line(x, height - 30, x, height - 30 - vals[i] * 100);  
  }
}

public void setup() {
  size(1280, 720);
  frameRate(60);
}
