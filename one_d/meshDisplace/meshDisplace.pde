import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

import processing.opengl.*;

HE_Mesh box;
WB_Render render;

String[] lines;
String[] values;

void setup() {
  size(800, 800, OPENGL);
  smooth();
  
  // load some data
  lines = loadStrings("../../data/1d_data.csv");
  // parse it
  values = lines[0].split(",");

  // make a long box
  HEC_Box boxCreator=new HEC_Box().setWidth(20).setWidthSegments(1).setHeight(20).setHeightSegments(1).setDepth(400).setDepthSegments(values.length);
  box = new HE_Mesh(boxCreator);

  // get ready to render it
  render=new WB_Render(this);
  int index = 0;
  
  // this is how we walk over a mesh
  for ( HE_Face f : box.getFacesAsList () ) {
    
    // normals are how we determine what direction a face is facing,
    // in this case we just want the ones facing upwards
    WB_Vector n = f.getFaceNormal();
    if(n.xf() == 0.0 && n.yf() == 1.0 && n.zf() == 0.0)
    {
      HE_Halfedge edge = f.getHalfedge();
      edge.getStartVertex().setY( edge.getStartVertex().yf() + float(values[index]));
      edge.getEndVertex().setY( edge.getEndVertex().yf() + float(values[index]));
      
      index++;
    }
  }

}

void draw() {
  
  // grey background
  background(120);
  
  // make some lights
  lights();
  
  // put it in the center
  translate(300, 300, 0);
  
  // let us roll it around
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  noStroke();

  // now draw the box
  render.drawFaces( box );

  stroke(0);
}