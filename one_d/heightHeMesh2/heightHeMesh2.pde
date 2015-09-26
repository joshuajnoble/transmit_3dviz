import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

import processing.opengl.*;

String FILE = "N47W121.hgt";
int W = 1201;
int H = 1201;

HE_Mesh mesh;
WB_Render render;
HEM_Extrude modifier;

double[][] heightData;

void setup() {

  heightData = load(FILE);

  size(1200, 1200, OPENGL);
  //smooth(8);

  HEC_Grid creator=new HEC_Grid();
  println(" 1 ");
  creator.setU(1200);// number of cells in U direction
  creator.setV(1200);// number of cells in V direction
  println(" 2 ");
  creator.setUSize(1200);// size of grid in U direction
  creator.setVSize(1200);// size of grid in V direction
  println(" 3 ");
  creator.setWValues(heightData);// displacement of grid points (W value)

  mesh=new HE_Mesh(creator);
  
  //mesh.simplify(new HES_TriDec().setGoal(600 * 600)); // this will take about 10 minutes

  //The WB_Render object provides functions to draw all kinds of objects form the library.
  render=new WB_Render(this); //"this" is the calling applet, the object needs this to call Processing's functions.
}

void draw() {
  background(255);
  //lights();
  translate(600, 600, 200);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  //fill(255);
  //noStroke();
  //render.drawFaces(mesh);
  stroke(0);
  render.drawEdges(mesh);
}


double[][] load(String filename) {
  // load the bytes into the array
  byte[] b = loadBytes(filename);
  // and copy them into the data array, two at a time
  double[][] data = new double[W+1][H];
  int index = 0;
  for (int y = 0; y < H; y++) {
    for (int x = 0; x < W; x++) {
      // messy
      int b0 = b[index];
      b0 = b0 >= 0 ? b0 : 256 + b0;
      int b1 = b[index + 1];
      b1 = b1 >= 0 ? b1 : 256 + b1;
      data[x][y] = ((double)(b0 * 256 + b1)/40.0);
      index += 2;
    }
  }
  return data;
}


