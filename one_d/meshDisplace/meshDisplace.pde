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
  
  lines = loadStrings("../../data/1d_data.csv");
  values = lines[0].split(",");

  HEC_Box boxCreator=new HEC_Box().setWidth(20).setWidthSegments(1).setHeight(20).setHeightSegments(1).setDepth(400).setDepthSegments(values.length);
  box = new HE_Mesh(boxCreator);

  render=new WB_Render(this);
  int index = 0;
  for ( HE_Face f : box.getFacesAsList () ) {
    //if(f.getLabel() == #ff0000 ) {
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
  background(120);
  lights();
  translate(300, 300, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  noStroke();

  for ( HE_Face f : box.getFacesAsList () ) {
    noStroke();
    fill( f.getLabel() );
    render.drawFace( f );
  }

  stroke(0);
}