import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;
import processing.sound.*;

SoundFile soundfile;

HE_Mesh mesh;
WB_Render render;

int divisor;

FFT fft;
Amplitude amp;

int bands = 512;
float[] spectrum = new float[bands];

int currentFace = 0;

void setup()
{
  size(800, 800, OPENGL);

  //Load a soundfile
  soundfile = new SoundFile(this, "arthur_russell.mp3");

  // These methods return useful infos about the file
  println("SFSampleRate= " + soundfile.sampleRate() + " Hz");
  println("SFSamples= " + soundfile.frames() + " samples");
  println("SFDuration= " + soundfile.duration() + " seconds");

  // Play the file in a loop
  soundfile.play();

  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this);
  // patch the AudioIn
  fft.input(soundfile, 512);
  
  // create an amplitude that can return the volume
  amp = new Amplitude(this);
  amp.input(soundfile);
  
  divisor = int(soundfile.duration() * 1000) / 1024;
  
  println( soundfile.duration() );
  println( );

  smooth(8);
  HEC_Torus creator=new HEC_Torus();
  creator.setRadius(40, 200); 
  creator.setTubeFacets(2);
  creator.setTorusFacets(1024);
  
  mesh=new HE_Mesh(creator); 
  HET_Diagnosis.validate(mesh);
  render=new WB_Render(this);
}


void draw()
{
  
  // do amplitude
  if(millis() % divisor < 10 )
  {
    
    float volume = amp.analyze();
    
    println(volume);
    
    HE_Face f = mesh.getFacesAsList ().get( currentFace * 2 );
    
    for( HE_Vertex v : f.getFaceVertices()) {
      if(!v.isVisited()) { 
        v.setZ( volume * 1000 );
        v.setVisited();
      }
    }
    
    currentFace++;
  }

  background(255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(400, 400, 100);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  //stroke(0);
  //render.drawEdges(mesh);
  noStroke();
  render.drawFaces(mesh);
}

void keyPressed()
{
  if(key == 'r')
  {
    HET_Export.saveToOBJ(mesh, "/Users/jnoble/code/Processing/export", "file");
  }
}