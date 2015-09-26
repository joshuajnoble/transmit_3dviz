import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

PeasyCam cam;
ArrayList<PVector> vecs;

void setup()
{
  size(640, 640, P3D);
  
  vecs = new ArrayList<PVector>();

  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(10);
  cam.setMaximumDistance(500);
  
  for (int j = 0; j < 11; j ++) {
    float m = random(0, 20);
//    for (int i = 0; i < 11; i+=2) {
    for (int i = 0; i < 11; i++) {
      PVector v = new PVector(i * 40, 10, j * 40);
//      PVector v2 = new PVector(i * 40, m, j * 40);
      vecs.add(v);
//      vecs.add(v2);
    }
  }

}


void draw()
{
  background(0);
  
  for (int j = 0; j < 11; j ++) {

    beginShape(QUAD_STRIP);
    
    for (int i = 0; i < 11; i++) {
//      float m = random(0, 20);
      vertex( i * 40, 10, j * 40 );
      vertex( i * 40, 10, (j+1) * 40 );
      //int index = (j * 11) + i;
      //vertex( vecs.get(index).x, vecs.get(index).y, vecs.get(index).z );
    }

    endShape();
  }
}

