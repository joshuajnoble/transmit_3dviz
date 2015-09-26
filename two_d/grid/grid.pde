import peasy.*;

PeasyCam cam;

String[] lines;
PFont body;
int num = 9; // Display this many entries on each screen.
int startingEntry = 0;  // Display from this entry number

void setup() {
  size(600, 600, P3D);
  fill(255);
  
  lines = loadStrings("UKSoccer.csv");
  
  println(lines);
  
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);
}

void draw() 
{
  background(0);
  lights();
  
  pushMatrix();
  for (int i = 1; i < lines.length; i++) { // skip the first line b/c it's a header
    //println(lines[i]);
    String[] pieces = split(lines[i], ","); // Load data into array
    if (pieces.length > 5) { // do we have the right number of elements?
      
      translate(0, -int(pieces[1])/2, 0);
      box(40, int(pieces[1]), 40);
      translate(40, int(pieces[1])/2, 0);
      
      translate(0, -int(pieces[2])/2, 0);
      box(40, int(pieces[2]), 40);
      translate(40, int(pieces[2])/2, 0);
      
      translate(0, -int(pieces[3])/2, 0);
      box(40, int(pieces[3]), 40);
      translate(40, int(pieces[3])/2, 0);
      
      translate(0, -int(pieces[4])/2, 0);
      box(40, int(pieces[4]), 40);
      translate(-120, int(pieces[4])/2, 40);
    }
  }
  popMatrix();
}
