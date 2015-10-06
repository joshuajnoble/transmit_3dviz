import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

import processing.opengl.*;

HE_Mesh box;
WB_Render render;

String[] lines;

float[] values;

color[] colors = { 
  #ECD078, #D95B43, #C02942, #542437, #53777A, #FFFFFF
};

void setup() {
  size(800, 800, OPENGL);
  smooth();

  lines = loadStrings("../../data/2d_data.csv");
  values = new float[lines.length * lines.length];
  println(lines.length * lines.length);
  for( int i = 0; i < lines.length; i++ )
  {
    String[] m = lines[i].split(",");
    //values[i] = new float[m.length];
    for( int j = 0; j < m.length; j++)
    {
      values[(i * m.length) + j] = Float.parseFloat(m[j]);
    }
  }


  //HEC_Box boxCreator=new HEC_Box().setWidth(400).setWidthSegments(1).setHeight(20).setHeightSegments(1).setDepth(400).setDepthSegments(1);
  HEC_Box boxCreator=new HEC_Box().setWidth(400).setWidthSegments(lines.length).setHeight(20).setHeightSegments(1).setDepth(400).setDepthSegments(lines.length);
  //boxCreator.setCenter(100, 100, 0).setZAxis(1, 1, 1);
  box = new HE_Mesh(boxCreator);

  // make our up-facing vertices red
  int currentColor = 0;
  for ( HE_Face f : box.getFacesAsList () ) {
    WB_Vector n = f.getFaceNormal();
    
    if(n.xf() == 0.0 && n.yf() == 1.0 && n.zf() == 0.0) {
      f.setLabel( #ff0000 );
    } else {
      f.setLabel( #00ff00 );
    }
    
  }
  
  // now extrude them
  int index = 0;
  for ( HE_Face f : box.getFacesAsList () ) {
  WB_Vector n = f.getFaceNormal();
  if(n.xf() == 0.0 && n.yf() == 1.0 && n.zf() == 0.0) {
    for( HE_Vertex v : f.getFaceVertices()) {
        
      if(!v.isVisited()) { 
        v.setY( v.yf() + (values[index] * 3) + 20.0 );
        index++;
        v.setVisited();
      }
    }
  }
  }

  render=new WB_Render(this);
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