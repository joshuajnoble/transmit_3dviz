import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

import processing.opengl.*;

int W, H;

HE_Mesh mesh;
WB_Render render;
HEM_Extrude modifier;

boolean drawPoints;

PImage heightImage;

void setup() {

  drawPoints = false;

  // this is the image that we'll use to get the height
  heightImage = loadImage("../../data/cz.png");
  W = heightImage.width;
  H = heightImage.height;
  size(1280, 960, P3D);

  // we can't make a mesh the size of the image (it's huge!)
  // so we'll make a mesh 1/4 the size of the image
  int quarterWidth = (W/4);
  int quarterHeight = (H/4);

  // an array to store all our of data
  double heightData[][] = new double[quarterWidth + 1][quarterHeight + 1];

  // we have to go backwards so the image is facing
  // the correct direction
  for (int y = quarterHeight; y > 0; y--) {
    for (int x = quarterWidth; x > 0; x--) {
      color c = heightImage.get(x*4, y*4);
      if (alpha(c) > 0)
      {
        float h = red(c);
        heightData[x][y] = -h;
      } else
      {
        heightData[x][y] = 0;
      }
    }
  }

  // make a thing that can make a grid
  HEC_Grid creator=new HEC_Grid();
  creator.setU(quarterWidth);// number of cells in U direction
  creator.setV(quarterHeight);// number of cells in V direction
  creator.setUSize(quarterWidth);// size of grid in U direction
  creator.setVSize(quarterHeight);// size of grid in V direction
  creator.setWValues(heightData);// displacement of grid points (W value)

  // now actually make the grid
  mesh=new HE_Mesh(creator);

  //The WB_Render object provides functions to draw all kinds of objects form the library.
  render=new WB_Render(this); //"this" is the calling applet, the object needs this to call Processing's functions.
}

void draw() {

  if ( drawPoints )
  {
    background(0);
    stroke(255);
    // roll it around so we can see all the parts of it
    translate(width/2, height/2, 200);
    rotateY(mouseX*1.0f/width*TWO_PI);
    rotateX(mouseY*1.0f/height*TWO_PI);
    
    // points is faster than a mesh but not that fast
    // so we need to get every other point in order to see
    // what we're doing
    for (int y = 0; y < H; y+=2) {
      for (int x = 0; x < W; x+=2) {
        color c = heightImage.get(y, x);
        float h = hue(c);
        // draw a point for each part of the 
        if (h > 0.0 && h < 250.0) {
          point(x, h, y);
        }
      }
    }
  } 
  else
  {
    translate(width/2, height/2, 200);
    rotateY(mouseX*1.0f/width*TWO_PI);
    rotateX(mouseY*1.0f/height*TWO_PI);
    background(0);
    lights();
    fill(255);
    noStroke();
    // just draw the faces, rather than the edges or lines
    render.drawFaces(mesh);
  }
}

// just a way to toggle between points and the mesh
void keyPressed()
{
  drawPoints = !drawPoints;
}