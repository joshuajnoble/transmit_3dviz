import ComputationalGeometry.*;

IsoWrap wrap;

void setup() {
  
  // set the size of our sketch
  size(500, 500, P3D);
  
  // make a wrap instance
  wrap = new IsoWrap(this);

  // make something to store our data
  ArrayList<PVector> points = new ArrayList<PVector>();

  // read our data
  String[] lines = loadStrings("positions.txt");
  for( int i = 0; i < lines.length; i++ )
  {
    String[] pieces = split(lines[i], '\t');
    if (pieces.length == 3) {
      int x = int(pieces[0]);
      int y = int(pieces[1]);
      int z = int(pieces[2]);
      points.add( new PVector(x,y,z) );
      wrap.addPt( new PVector(x,y,z) );
    }
  }
}

void draw(){
  
  background(220);
  lights();  
  float zm = 250;
  float sp = 0.01 * frameCount;
  camera(zm * cos(sp), zm * sin(sp), zm, 0, 0, 0, 0, 0, -1);

  noStroke();

  fill(255,255,0);
  //stroke(100);
  wrap.plot();
}