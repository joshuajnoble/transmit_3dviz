import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;


HE_Mesh mesh;
WB_Render render;

void setup() {
  
  // set the size of our sketch
  size(800, 800, OPENGL);
  
  // make a wrap instance
//  wrap = new IsoWrap(this);

  // make something to store our data
  ArrayList<PVector> points = new ArrayList<PVector>();

  // read our data
  String[] lines = loadStrings("positions.txt");
  
  HEC_ConvexHull creator=new HEC_ConvexHull();
  
  //Array of all points
  float[][] vertices=new float[lines.length][3];
  
  for( int i = 0; i < lines.length; i++ )
  {
    String[] pieces = split(lines[i], '\t');
    if (pieces.length == 3) {
      int x = int(pieces[0]);
      int y = int(pieces[1]);
      int z = int(pieces[2]);
      points.add( new PVector(x,y,z) );
      vertices[i][0] = x;
      vertices[i][1] = y;
      vertices[i][2] = z;
    }
  }
  
  creator.setPoints(vertices);

  mesh=new HE_Mesh(creator);
  HET_Diagnosis.validate(mesh);
  render=new WB_Render(this);
  
}

void draw(){
  
//  background(220);
//  lights();  
//  float zm = 250;
//  float sp = 0.01 * frameCount;
//  camera(zm * cos(sp), zm * sin(sp), zm, 0, 0, 0, 0, 0, -1);
//
//  noStroke();
//
//  fill(255,255,0);
//  //stroke(100);
//  wrap.plot();

  background(120);
  lights();
  translate(400, 400, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  noStroke();
  render.drawFaces(mesh);
  stroke(0);
  render.drawEdges(mesh);
}
