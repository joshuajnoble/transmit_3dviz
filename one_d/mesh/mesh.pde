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
  
}


void draw()
{
  background(0);
  
  for (int j = 0; j < 11; j ++) {

    beginShape(QUAD_STRIP);
    
    for (int i = 0; i < 11; i++) {
      vertex( i * 40, sin(i) * 10, j * 40 );
      vertex( i * 40, sin(i) * 10, (j+1) * 40 );
    }

    endShape();
  }
}