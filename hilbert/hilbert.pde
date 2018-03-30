ArrayList<int[]> hilbert = new ArrayList<int[]>();
int N = (int) Math.pow(2, 6);

void setup() {
  size(800, 800);
  frameRate(60);
  
  for(int i = 0; i < N * N; i++) {
    hilbert.add(hIndexToCoords(i, N));
  }
}

int last2bits(int x) { return x & 3; }

int[] hIndexToCoords(int hIndex, int N) {
  int[][] positions = {
    {0, 0},
    {0, 1},
    {1, 1},
    {1, 0}
  };
  
  int[] tmp = positions[last2bits(hIndex)];
  hIndex >>>= 2;
  
  int x = tmp[0];
  int y = tmp[1];
  int tmpC = 0;
  
  for(int n = 4; n <= N; n *= 2) {
    int n2 = n / 2;
    
    switch(last2bits(hIndex)) {
      case 0:
        tmpC = x; x = y; y = tmpC;
        break;
      case 1:
        y += n2;
        break;
      case 2:
        x += n2;
        y += n2;
        break;
      case 3:
        tmpC = y;
        y = n2 - 1 - x;
        x = n2 - 1 - tmpC;
        x += n2;
        break;
    }
    
    hIndex >>>= 2;
  }
  
  return new int[]{x, y};
}

float amount = 0.5;

void draw() {
  background(0);
  
  //println(frameRate);
  int[] prev = {0, 0};
  int[] cur = {0, 0};
  float dm = 0.0075;
  float scl = width / N;
  float factor = (2 * Math.abs((amount % 1) - 0.5));
  
  amount += dm;
  
  for(int i = 0; i < N * N * factor; i++) {
    cur = hilbert.get(i);
    float mul = (float) i / (N * N * factor);
    //fill(150, 255 * mul, 100);
    //stroke(150, 255 * mul, 100);
    //ellipse(cur[0] * (width / N) + width / 40, cur[1] * (height / N) + width / 40, 3, 3);
    fill(255 * mul, 255 - 200 * mul, 255 - 100 * mul);
    stroke(255 * mul, 255 - 200 * mul, 255 - 100 * mul);
    line(prev[0] * scl, prev[1] * scl, cur[0] * scl, cur[1] * scl);
    prev = cur;
  }
}