import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

import processing.opengl.*;

HE_Mesh box;
WB_Render render;

void setup() {
  size(800, 800, OPENGL);
  smooth();

  HEC_Box boxCreator=new HEC_Box().setWidth(20).setWidthSegments(1).setHeight(20).setHeightSegments(1).setDepth(400).setDepthSegments(40);
  //boxCreator.setCenter(100, 100, 0).setZAxis(1, 1, 1);
  box = new HE_Mesh(boxCreator);

//  int currentColor = 0;
//  for ( HE_Face f : box.getFacesAsList () ) {
//
//    println(f.getFaceNormal());
//    WB_Vector v = f.getFaceNormal();
//    
//    if(v.xf() == 0.0 && v.yf() == 1.0 && v.zf() == 0.0) {
//      f.setLabel( #ff0000 );
//    } else {
//      f.setLabel( #00ff00 );
//    }
//    
//  }

  //Subdividors work just like modifiers.
  //HES_Planar planarSubdividor = new HES_Planar();

  //Subdivide the mesh by calling a subdividor in a subdivide command
//  box.subdivide(planarSubdividor, 4);

  render=new WB_Render(this);

  for ( HE_Face f : box.getFacesAsList () ) {
    //if(f.getLabel() == #ff0000 ) {
    WB_Vector n = f.getFaceNormal();
    if(n.xf() == 0.0 && n.yf() == 1.0 && n.zf() == 0.0)
    {
      float move = random(0, 60);
      HE_Halfedge edge = f.getHalfedge();
      edge.getStartVertex().setY( edge.getStartVertex().yf() + move);
      edge.getEndVertex().setY( edge.getEndVertex().yf() + move);
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

  //  render.drawFaces(box);
  stroke(0);
  //render.drawEdges(box);
}

