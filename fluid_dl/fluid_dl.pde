float videoScale;

// Number of columns and rows in our system
int cols, rows;

int N = 64;

int SIZE = (N+2)*(N+2);

//v is velocities
float[] u = new float[SIZE];
float[] v = new float[SIZE];
float[] u_prev = new float[SIZE];
float[] v_prev = new float[SIZE];

float[] dens = new float[SIZE];
float[] dens_prev = new float[SIZE];

//Entry is true if the grid contains an object
boolean[] object_space_grid = new boolean[SIZE];

float force = 5.0f;
float source = 100.0f;
float dt = 0.4f;
float visc = 0.0f;
float diff = 0.0f;

//For ui
boolean mousePressed = false;
boolean mLeftPressed = false;
boolean mRightPressed = true;
int mx, my; //Current mouse position
int omx, omy; //Old mouse position
boolean drawVel = false;
boolean advectNormalStep = true;
boolean object_space = false;
boolean fancyColours = false;

//Helper function to get an element from a 1D array as if it were a 2D array
int IX(int i, int j)
{
  return (i + ((N+2) * j));
}

void densStep(int n, float[] x, float[] x0, float[] u, float[] v, float diff, float dt)
{
  addSource(n, x, x0, dt);
  float[] temp = x0;
  x0 = x;
  x = temp;
  //   swap(x0, x);
  diffuse(n, 0, x, x0, diff, dt);
  //   swap(x0, x);
  temp = x0;
  x0 = x;
  x = temp;
  advect(n, 0, x, x0, u, v, dt);
}

void diffuse(int n, int b,  float[] x, float[] x0, float diff, float dt)
{
  int i, j, k;
  float a = dt * diff*n*n;
  for(k=0 ; k<20; k++)
  {
    for(i=1;i<=n;i++)
    {
      for(j=1;j<=n;j++)
      {
        x[IX(i,j)] = (x0[IX(i,j)] +
            a * (x[IX(i - 1, j)] + x[IX(i + 1,j)] + x[IX(i, j - 1)] + x[IX(i,j + 1)])) / (1 + (4 * a));
      }
    }
  }
}

void advect(int n, int b, float[] d, float[] d0, float[] u, float[] v, float dt) {
  int i0, j0, i1, j1;
  float x, y, s0, t0, s1, t1, dtw, dth;
  
  dtw = dt * N;
  dth = dt * N;
  
  for(int i = 1; i < N - 1; i++) {
    for(int j = 1; j < N - 1; j++) {
      x = i - dtw * u[IX(i,j)];
      y = j - dth * v[IX(i,j)];
    
      if(x < 0.5f)
      {
        x = 0.5f;
      }
      if(x > (N+0.5f))
      {
        x = N + 0.5f;
      }
      i0 = (int)x;
      i1 = i0 + 1;
    
      if(y < 0.5f)
      {
        y = 0.5f;
      }
      if(y > (N+0.5f))
      {
        y = N + 0.5f;
      }
      j0 = (int)y;
      j1 = j0 + 1;
    
      s1 = x - i0;
      s0 = 1 - s1;
    
      t1 = y - j0;
      t0 = 1 - t1;
      
      float a = s0 * (t0 * d0[IX(i0,j0)] + t1 * d0[IX(i0,j1)]) +
        s1 * (t0 * d0[IX(i1,j0)] + t1 * d0[IX(i1,j1)]);
      d[IX(i,j)] = a;
    }
  }
}

void draw()
{
  mx = mouseX;
  my = mouseY;
  
  getForcesFromUI(dens_prev, u_prev, v_prev);
  //velStep(N, u, v, u_prev, v_prev, visc, dt);
  densStep(N, dens, dens_prev, u, v, diff, dt);

  //    drawRectangles();

  background(0);

  drawDensity();
}

void setup() {
  size(512,512, P3D);
  background(0);
  //    frameRate(30);
  //    lights();
  //   ortho(0.0f, 1.0f, 1.0f, 0.0f, -10.0f, 10.0f);
  //    ortho(0,1, 0,1, -10,20);

  // Initialize columns and rows
  //  cols = width/videoScale;
  //  rows = height/videoScale;
  videoScale = height / (N+2);
  rows = N+2;
  cols = N+2;
  clearData();
}

void clearData()
{
  int i;
  int sz = (N+2)*(N+2);

  for(i=0;i<sz; i++)
  {
    u[i] = 0.0f;
    v[i] = 0.0f;
    u_prev[i] = 0.0f;
    v_prev[i] = 0.0f;
    dens[i] = 0.0f;
    dens_prev[i] = 0.0f;
    object_space_grid[i] = false;
  }
  
  int j;
  for(i=N/4;i<=(3*N/4);i++)
  {
    for(j=N/4;j<=(3*N/4);j++)
    {
      object_space_grid[IX(i,j)] = true;
    }
  }

}

void getForcesFromUI(float[] d, float[] u, float[] v)
{
  int i, j;
  int size = (N+2)*(N+2);

  for(i=0;i<size;i++)
  {
    u[i] = 0.0f;
    v[i] = 0.0f;
    d[i] = 0.0f;
  }

  if(! mousePressed)
  {
    return;
  }

  i = (int)((mx / (float)width)*N+1);
  j = (int)((my / (float)height)*N+1);

  if( (i<1) || (i>N)
      || (j<1) || (j>N))
  {
    return;
  }

  if(mLeftPressed)
  {
    u[IX(i,j)] = force * (mx-omx);
    v[IX(i,j)] = -force * (omy-my);
  }

  if(mRightPressed)
  {
    d[IX(i,j)] = source; //Set density to initial value
  }

  omx = mx;
  omy = my;
}

void addSource(int n, float[] x, float[] s, float dt)
{
  int i;
  int sz = (n+2)*(n+2);

  for(i=0;i<sz;i++)
  {
    x[i] += dt*s[i];
  }
}

void drawDensity()
{
  int i,j;
  float x, y, h, d00, d01, d10, d11;

  h = 1.0f / (float)N;

  for(i=0;i<=N;i++)
  {
    x = (i-0.5f)*h;

    for(j=0;j<=N;j++)
    {
      y = (j-0.5f)*h;

      d00 = dens[IX(i,j)];
      d01 = dens[IX(i,j+1)];
      d10 = dens[IX(i+1,j)];
      d11 = dens[IX(i+1,j+1)];

      //d00 *= 255;
      //d10 *= 255;
      //d11 *= 255;
      //d01 *= 255;

      beginShape(QUADS);


      float threshold = 200.0f;
      stroke(d00, d00, d00);
      fill(d00, d00, d00);
      println(x);

      drawPointOnScreen(x, y);

      stroke(d10, d10, d10);
      fill(d10, d10, d10);
      
      drawPointOnScreen(x+h, y);

      stroke(d11,d11,d11);
      fill(d11, d11, d11);

      drawPointOnScreen(x+h, y+h);

      stroke(d01,d01,d01);
      fill(d01, d01, d01);

      drawPointOnScreen(x, y+h);

      endShape();
    }
  }
}

void drawPointOnScreen(float x, float y)
{
  vertex(x * width, y * height);
}

void mousePressed() {
  mousePressed = true;

  omx = mouseX;
  mx = mouseX;
  omy = mouseY;
  my = mouseY;

  if(mouseButton == LEFT)
  {
    mLeftPressed = true;
  }
  else if (mouseButton == RIGHT)
  {
    mRightPressed = true;
  }
}

void mouseReleased()
{
  mousePressed = false;

  if(mouseButton == LEFT)
  {
    mLeftPressed = false;
  }
  else if (mouseButton == RIGHT)
  {
    mRightPressed = false;
  }
}