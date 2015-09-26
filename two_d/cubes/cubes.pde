import peasy.*;

String[] lines;
int index = 0;

PeasyCam cam;

void setup() {
  size(500, 500, P3D);
  background(0);
  stroke(255);
  frameRate(12);
  lines = loadStrings("positions.txt");
  
    cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);

}

void draw() {
  
  background(0);
  lights();
  
  for(int i = 0; i < lines.length; i++)
  {
    String[] pieces = split(lines[i], '\t');
    if (pieces.length == 3) {
      int x = int(pieces[0]);
      int y = int(pieces[1]);
      int z = int(pieces[2]);
      translate(20, (-y/2), 0);
      box(20, y, z); // we're mapping both y and z to data
      translate(0, (y/2), 0);
    }
  }  
}
