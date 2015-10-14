import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

import processing.sound.*;

// this is what we'll use to load in the audio file
// and then play back the sound as well as analyze how loud it is
// at every point
SoundFile soundfile;

HE_Mesh mesh;
WB_Render render;
HE_Selection selection;

int divisor;

FFT fft;
Amplitude amp;

long lastMillis;

boolean playing = false;
boolean drawSelection = false;

int bands = 512;
float[] spectrum = new float[bands];

int currentFace = 0;

void setup()
{
  size(800, 800, OPENGL);

  //Load a soundfile
  soundfile = new SoundFile(this, "arthur_russell.mp3");
  
  // Play the file in a loop
  soundfile.play();

  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, 512);
  // patch the AudioIn
  fft.input(soundfile);

  // create an amplitude that can return the volume
  amp = new Amplitude(this);
  amp.input(soundfile);
  
  // figure out how often we should sample the file
  // so that the number of faces matches the number of times
  // we look at the audio file
  divisor = int(soundfile.duration() * 1000) / 1024;

  // make a torus to use to deform with audio data
  HEC_Torus creator=new HEC_Torus();
  creator.setRadius(40, 200); 
  creator.setTubeFacets(6);
  creator.setTorusFacets(1024);

  mesh=new HE_Mesh(creator); 
  
  // a selection is a way to keep track of just some faces in your mesh 
  selection = new HE_Selection(mesh);
  HE_FaceIterator fItr=new HE_FaceIterator(mesh);
  HE_Face f;
  
  // we only want the faces that look upwards
  // so we look at the normal of a face and if it's looking the
  // right direction, we add it to our selection
  while (fItr.hasNext ()) {
    f=fItr.next();
    println(f.getFaceNormal() );
    //we're looking for --0.49 more or less
    if (f.getFaceNormal().zf() + 0.5 < 0.1 && f.getFaceNormal().yf() < 0.00001 && f.getFaceNormal().yf() > -0.00001) {
      selection.add(f);
    }
  }

  // draw it
  render=new WB_Render(this);

  playing = true;
  lastMillis = 0;
}


void draw()
{
  // if our song is still playing and we still have faces to manipulate 
  if (playing && currentFace > mesh.getFacesAsList ().size())
  {
    playing = false;
    // if we're done with playing the audio file, go ahead and save the obj
    // you'll need to change the path of the file save probably :)
    HET_Export.saveToOBJ(mesh, "/Users/jnoble/code/Processing/export", "file");
    
  } 
  else if (playing)
  {
    // is it time to get another sample?
    if (millis() - lastMillis > divisor )
    {
      lastMillis = millis();
      //  get the volume
      float volume = amp.analyze();
      
      // get the next face
      HE_Face f = selection.getFacesAsList ().get( currentFace );

      // move all of it's vertices around
      for ( HE_Vertex v : f.getFaceVertices()) {
        v.setZ( v.zf() + min(-5, (volume * -500)) );
      }
      currentFace++;
    }
  }

  // draw everything
  background(255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(400, 400, 100);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  noStroke();
  
  if(!drawSelection)
  {
    render.drawFaces(mesh);
  } 
  else // if you want to just see the selection, uncomment this
  {
    render.drawFaces(selection);
  }
}

void keyPressed()
{
  if (key == 'r')
  {
    HET_Export.saveToOBJ(mesh, "/Users/jnoble/code/Processing/export", "file");
  }
  if(key == 'f')
  {
    drawSelection = !drawSelection;
  }
}