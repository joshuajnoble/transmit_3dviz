import peasy.*;
import processing.opengl.*;
 
PeasyCam cam;

String FILE = "../../data/N48W123.hgt";
int W = 1201;
int H = 1201;

short[][] data;
 
void setup() {
  size(1280, 960, OPENGL);
  cam = new PeasyCam(this, 1000);
  data = load(FILE);
  
}
 
void draw() {
  background(255);
  //translate(-width / 2, -height / 2);
  for (int y = 0 ; y < H ; y += 10) {
    for (int x = 0 ; x < W ; x += 10) {
      point(x - (W / 2), -data[x][y]/8, y - (H / 2));
    }
  }
}
 
short[][] load(String filename) {
  // load the bytes into the array
  byte[] b = loadBytes(filename);
  // and copy them into the data array, two at a time
  short[][] data = new short[W][H];
  int index = 0;
  for (int y = 0 ; y < H ; y++) {
    for (int x = 0 ; x < W ; x++) {
      // messy
      int b0 = b[index];
      b0 = b0 >= 0 ? b0 : 256 + b0;
      int b1 = b[index + 1];
      b1 = b1 >= 0 ? b1 : 256 + b1;
      data[x][y] = (short)(b0 * 256 + b1);
      index += 2;
    }
  }
  return data;
}