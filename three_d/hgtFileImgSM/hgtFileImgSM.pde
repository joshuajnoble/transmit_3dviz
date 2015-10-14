import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

import peasy.*;
import processing.opengl.*;
 
PeasyCam cam;

HE_Mesh mesh;
WB_Render render;
HEM_Extrude modifier;

int W,H;
double[][] heightData;

PImage heightImage;
 
void setup() {
  
  cam = new PeasyCam(this, 1000);
 
  // this is a height map of Prague color coded
  heightImage = loadImage("../../data/Prague.png");
  W = heightImage.width;
  H = heightImage.height;
  size(1280, 960, P3D);

  heightData = new double[W+1][H+1];
  
  // we have to go backwards so the image
  // is drawn correctly
  for (int y = H ; y > 0 ; y--) {
    for (int x = W ; x > 0 ; x--) {
      color c = heightImage.get(x, y);
       // in this image red is high and blue is low, so 
       // let's look up each color and then store how red & blue it is
      float h = red(c) - blue(c);
      heightData[x][y] = h/10;
    }
  }
  
  // now we make a grid
  HEC_Grid creator=new HEC_Grid();
  println(" 1 ");
  creator.setU(W);// number of cells in U direction
  creator.setV(H);// number of cells in V direction
  println(" 2 ");
  creator.setUSize(W);// size of grid in U direction
  creator.setVSize(H);// size of grid in V direction
  println(" 3 ");
  // this is where we use the height data that we pulled from the image
  creator.setWValues(heightData);

  // now create the mesh
  mesh=new HE_Mesh(creator);
  
  //The WB_Render object provides functions to draw all kinds of objects form the library.
  render=new WB_Render(this); //"this" is the calling applet, the object needs this to call Processing's functions.

  
}
 
void draw() {
  
  background(255);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  stroke(0);
  render.drawEdges(mesh);
}