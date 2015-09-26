import nervoussystem.obj.*;


boolean record;
int X, Y;
PGraphics bg, hover;

Globe w;
Table t;
DataHolder[] data;

////////////////////////////////////////////////////////////////////////////////////////

void setup() {
  //Buffers
  size(1000, 900, P3D); 
  //General settings
  X = width/2;
  Y = height/2;

  frameRate(30);
  //Objects
  w = new Globe(250, 24, "w.png");
  t = new Table("coords.csv");
  data = new DataHolder[t.getNumRows()-1];
  
  for (int i=0; i<data.length; i++) {
    data[i]= new DataHolder(i);
  }
}

////////////////////////////////////////////////////////////////////////////////////////

void draw() {
  //background(bg);
  background(0);
  //hover.beginDraw(); 
  //hover.background(0); 
  //hover.endDraw();
  lights();
  w.update();
  render(X, Y); 
  //detectHover();
}

void render(int x, int y) {
  
  if (record) {
    beginRecord("nervoussystem.obj.OBJExport", "filename.obj");
  }
  
  //hover.beginDraw();
  pushMatrix();
  translate(x, y);
 // hover.translate(x, y);
  pushMatrix();
  rotateX(w.rotation.x);
  rotateY(w.rotation.y);
  //hover.rotateX(w.rotation.x);
  //hover.rotateY(w.rotation.y);
  fill(#cccccc);
  w.render();
  for (int i=0; i<data.length; i++)
  {
    //data[i].renderBox(g, w, X, Y);
    data[i].renderBox(w, X, Y);
    //data[i].renderBox(hover);
  }
  popMatrix();
  popMatrix();
  //hover.endDraw();
  
  if (record) {
    endRecord();
    record = false;
  }
  
}

////////////////////////////////////////////////////////////////////////////////////////

void mouseDragged() {
  if (mouseButton==LEFT) {
    w.addRotation(mouseX, mouseY, pmouseX, pmouseY);
  }
}

void keyPressed()
{
  if (key == 'r') {
    record = true;
  }
}

