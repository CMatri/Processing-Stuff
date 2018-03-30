int swidth = 1080;
int sheight = 1080;
int gscale = 7;
int w = swidth / gscale;
int h = sheight / gscale;
int gsize = w * h;
float dt = 0.4f;

float[] u = new float[gsize];
float[] v = new float[gsize];
float[] u_prev = new float[gsize];
float[] v_prev = new float[gsize];
float[] dens = new float[gsize];
float[] dens_prev = new float[gsize];

PImage densImg;
PGraphics velImg;

int mx = 0, my = 0, omx = 0, omy = 0;

int ix(int i, int j) { 
  return i + w * j;
}

void addSource(float[] x, float[] s, float dt) {
  for(int i = 0; i < gsize; i++) {
    x[i] += dt * s[i];
  }
}

void diffuse(int b, float[] x, float[] x0, float diff, int iters, float dt) { 
  int i, j, k; 
  float a = dt * diff * w * h; 
 
  for(k = 0; k < iters; k++) { 
    for(i = 1; i < w - 1; i++) { 
      for(j = 1; j < h - 1; j++) {
        x[ix(i, j)] = (x0[ix(i, j)] + a * (x[ix(i - 1, j)] + x[ix(i + 1, j)] + x[ix(i, j - 1)] + x[ix(i, j + 1)])) / (1 + (4 * a));
      } 
    }
    setBnd(b, x);
  } 
}

void advect(int b, float[] d, float[] d0, float[] u, float[] v, float dt) {
  int i0, j0, i1, j1;
  float x, y, s0, t0, s1, t1, dtw, dth;
  
  dtw = dt * w;
  dth = dt * h;
  
  for(int i = 1; i < w - 1; i++) {
    for(int j = 1; j < h - 1; j++) {
      x = i - dtw * u[ix(i,j)];
      y = j - dth * v[ix(i,j)];
    
      x = max(0.5f, x);
      x = min(w - 2 + 0.5f, x);
      y = max(0.5f, y);
      y = min(h - 2 + 0.5f, y);
      
      i0 = (int)x;
      i1 = i0 + 1;
      j0 = (int)y;
      j1 = j0 + 1;
    
      s1 = x - i0;
      s0 = 1 - s1;
    
      t1 = y - j0;
      t0 = 1 - t1;
      
      //i0 = min(w - 1, i0);
      //i1 = min(w - 1, i1);
      //j0 = min(h - 1, j0);
      //j1 = min(h - 1, j1);
      
      float a = s0 * (t0 * d0[ix(i0,j0)] + t1 * d0[ix(i0,j1)]) +
        s1 * (t0 * d0[ix(i1,j0)] + t1 * d0[ix(i1,j1)]);
      d[ix(i,j)] = a;
    }
  }
  
  setBnd(b, d);
}

void project(float[] u, float[] v, float[] p, float[] div) {
  float hw = 1.0 / w;
  float hh = 1.0 / h;
  
  for(int i = 1; i < w - 1; i++) {
    for(int j = 1; j < h - 1; j++) {
      div[ix(i, j)] = -0.5 * hw * (u[ix(i + 1, j)] - u[ix(i - 1, j)] + 
                              v[ix(i, j + 1)] - v[ix(i, j - 1)]);
      p[ix(i, j)] = 0;
    }
  }
  
  setBnd(0, div);
  setBnd(0, p);
  
  for(int k = 0; k < 20; k++) {
    for(int i = 1; i < w - 1; i++) {
      for(int j = 1; j < h - 1; j++) {
        p[ix(i, j)] = (div[ix(i, j)] + p[ix(i - 1, j)] + p[ix(i + 1, j)] + p[ix(i, j - 1)] + p[ix(i, j + 1)]) / 4;
      }
    }
    setBnd(0, p);
  }
  
  for(int i = 1; i < w - 1; i++) {
    for(int j = 1; j < h - 1; j++) {
      u[ix(i, j)] -= 0.5 * (p[ix(i + 1, j)] - p[ix(i - 1, j)]) / hw;
      v[ix(i, j)] -= 0.5 * (p[ix(i, j + 1)] - p[ix(i, j - 1)]) / hh;
    }
  }
  
  setBnd(1, u);
  setBnd(2, v);
}

void densStep(float[] x, float[] x0, float[] u, float[] v, float diff, int iters, float dt) {
  addSource(x, x0, dt);
  
  float[] temp = x0;
  x0 = x;
  x = temp;
  
  diffuse(0, x, x0, diff, iters, dt);
  
  temp = x0;
  x0 = x;
  x = temp;   
  
  advect(0, dens, dens_prev, u, v, dt);
}

void velStep(float[] u, float[] v, float[] u0, float[] v0, float visc, float dt) {
  addSource(u, u0, dt);
  addSource(v, v0, dt);
  
  float[] temp = u0;
  u0 = u;
  u = temp;
  
  diffuse(1, u, u0, visc, 20, dt);

  temp = v0;
  v0 = v;
  v = temp;
  
  diffuse(2, v, v0, visc, 20, dt);
  project(u, v, u0, v0);
  
  temp = u0;
  u0 = u;
  u = temp;
  temp = v0;
  v0 = v;
  v = temp;
  
  advect(1, u, u0, u0, v0, dt);
  advect(2, v, v0, u0, v0, dt);
  project(u, v, u0, v0);
}

void setBnd(int b, float[] x) {
  for(int i = 0; i < w - 1; i++) {
    x[ix(0, i)] = b == 1 ? -x[ix(1, i)] : x[ix(1, i)];
    x[ix(w - 1, i)] = b == 1 ? -x[ix(w - 2, i)] : x[ix(w - 2, i)];    
  }
  
  for(int i = 0; i < h - 1; i++) { 
    x[ix(i, 0)] = b == 2 ? -x[ix(i, 1)] : x[ix(i, 1)];
    x[ix(i, h - 1)] = b == 2 ? -x[ix(i, h - 2)] : x[ix(i, h - 2)];
  }
  
  x[ix(0, 0)] = 0.5 * (x[ix(1, 0)] + x[ix(0, 1)]);
  x[ix(0, h - 1)] = 0.5 * (x[ix(1, h - 1)] + x[ix(0, h - 1)]);
  x[ix(w - 1, 0)] = 0.5 * (x[ix(w - 2, 0)] + x[ix(w - 1, 1)]);
  x[ix(w - 1, h - 1)] = 0.5 * (x[ix(w - 2, h - 1)] + x[ix(w - 1, h - 2)]);
}

void setup() {
  size(0, 0, P2D);
  surface.setResizable(true);
  
  frameRate(60);
  
  densImg = createImage(w, h, ALPHA);
  velImg = createGraphics(width, height);
  densImg.loadPixels();
  
  for(int i = 0; i < gsize; i++) {
    dens_prev[i] = 0.0f;
    dens[i] = 0.0f;
    u[i] = 0.0f;
    v[i] = 0.0f;
    u_prev[i] = 0.0f;
    v_prev[i] = 0.0f;
  }
}

void draw() {
  if(width < swidth || height < sheight) {
    surface.setSize(swidth, sheight);
    surface.setLocation(displayWidth / 2 - width / 2, displayHeight / 2 - height / 2);
  }
  
  for(int i = 0; i < gsize; i++) {
    dens_prev[i] = 0.0f;
    u_prev[i] = 0.0f;
    v_prev[i] = 0.0f;
  }

  input();
  velStep(u, v, u_prev, v_prev, 0.0000, dt);
  densStep(dens, dens_prev, u, v, 0.0000, 20, dt);
  
  background(0);
  renderDensityTexture();
  //renderVelocityTexture();
  
  textSize(20);
  fill(0, 102, 153);
  text(frameRate, 0, height - 10);
}

void renderDensityTexture() {
  densImg.loadPixels();
  
  for (int i = 0; i < gsize; i++) {
    int c = (int) min(255, dens[i]);
    densImg.pixels[i] = color(c);
  }
  
  densImg.updatePixels();
  image(densImg, 10, 10, width - 20, height - 20);
}

void renderVelocityTexture() {
  float scale = 600.0;
  float mn = 100;
  
  velImg.beginDraw();
  velImg.background(0, 0, 0, 0);
  for(int x = 0; x < w; x++) {
    for(int y = 0; y < h; y++) {
      velImg.stroke(50, dens[ix(x, y)], 50);
      float x1 = x + max(-mn, min(mn, u[ix(x, y)] * scale));
      float y1 = y + max(-mn, min(mn, v[ix(x, y)] * scale));
      if(abs(y1 - (y * gscale)) > 2) println(abs(y1 - (y * gscale)));
      velImg.line(x * gscale, y * gscale, x1 * gscale, y1 * gscale);
    }
  }
  velImg.stroke(0, 0, 0);
  velImg.endDraw();
  
  image(velImg, 0, 0, width, height);
}

void input() {
  if(mousePressed) {
    mx = mouseX / gscale;
    my = mouseY / gscale;
      
    float[] src = new float[gsize];
    int r = 6;
    
    if(mouseButton == LEFT) {
      for(int x = mx - r; x < mx + r; x++) {
        for(int y = my - r; y < my + r; y++) {
          src[max(0, min(gsize - 1, ix(x, y)))] = 220;
          u_prev[ix(x, y)] = 0.2f * (mx - omx);
          v_prev[ix(x, y)] = -0.2f * (omy - my); 
        }
      } 
    } else {
      u_prev[ix(mx, my)] = 50.0f * (mx - omx);
      v_prev[ix(mx, my)] = -50.0f * (omy - my);     
    }
    
    addSource(dens_prev, src, dt);
      
    omx = mx;
    omy = my;
  }
}