/*
# glfw_png

ng view using lodepng and glfw.

no image rescale yet.

lodepng is not mine, only this code.
*/

//zlib license, 8l, 2016

#include <GLFW/glfw3.h>
#include <stdlib.h>
#include <stdio.h>
#include "lodepng.h"

GLFWwindow* w;

uint32_t screen_w = 512; //640;
uint32_t screen_h = 512; //480;

uint32_t img_w  = 512;
uint32_t img_h  = 512;

typedef std::vector<uint8_t> v;

v read_png(const char * fn, uint32_t w, uint32_t h)
{
  v pic;
  if(!lodepng::decode(pic, w, h, fn))
    fprintf(stderr, "read png error\n");
  return pic;
}

void init(v& img, double& gl_w, double& gl_h)
{
  size_t w2 = 1;
  size_t h2 = 1;
  glfwMakeContextCurrent(w);

  glViewport(0, 0, screen_w, screen_h);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(0, screen_w, screen_h, 0, -1, 1);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glDisable(GL_CULL_FACE);
  glDisable(GL_DEPTH_TEST);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glEnable(GL_BLEND);
  glDisable(GL_ALPHA_TEST);

  while(w2 < img_w)
   w2 *= 2;
  while(h2 < img_h)
   h2 *= 2;
  gl_w=(double)img_w/w2;
  gl_h=(double)img_h/h2;
  
  v img2(w2*h2*4);
  for(size_t y=0; y<img_h; y++)
  for(size_t x=0; x<img_w; x++)
  for(size_t c=0; c<4; c++)
    img2[4*w2*y+4*x+c]=img[4*img_w*y+4*x+c];

  glEnable(GL_TEXTURE_2D);
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  glTexImage2D(GL_TEXTURE_2D, 0, 4, w2, h2, 0, GL_RGBA, GL_UNSIGNED_BYTE, &img2[0]);
}

void render(double gl_h, double gl_w, uint32_t img_w, uint32_t img_h)
{
  glBegin(GL_QUADS);
  glTexCoord2d(0,0);
  glVertex2f(0,0);
  glTexCoord2d(gl_w,0);
  glVertex2f(img_w,0);
  glTexCoord2d(gl_w,gl_h);
  glVertex2f(img_w,img_h);
  glTexCoord2d(0,gl_h);
  glVertex2f(0,img_h);
  glEnd();
}

int main(void)
{
  double gl_w;
  double gl_h;
  const char *fn = "Lenna.png";
  v img = read_png(fn, img_w, img_h);

  glfwInit();
  w = glfwCreateWindow(screen_w, screen_h, "Hello World", NULL, NULL);

  init(img, gl_w, gl_h);

  while (!glfwWindowShouldClose(w))
  {
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    render(gl_w, gl_h, img_w, img_h);
    glfwSwapBuffers(w);
    glfwPollEvents();
  }

  glfwTerminate();
  return 0;
}

  
