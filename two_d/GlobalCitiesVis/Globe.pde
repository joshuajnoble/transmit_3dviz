//A generic class to render textured spheres. The code is extracted from Flink Labs´s work. /////////////////////////
//At the beginning I started with the "Textured Sphere" example on the GL section of processing examples... /////////
//Bad election... that code isn´t a good base indeed! It´s all messed up...//////////////////////////////////////////
//I´ve slightly improved performance, removing unnecessary operations from the render() method.//////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Globe {

  
  PImage txtMap;
  int globeRadius; 
  float rWRatio, rHRatio, ROTATION_FACTOR=.01*DEG_TO_RAD;
  PVector rotation, rotSpeed;

  // Textured sphere implementation 
  float[][] 
    texturedSphereX, 
    texturedSphereY, 
    texturedSphereZ, 
    texturedSphereU, 
    texturedSphereV; 
  int texturedSphereDetail;

  ////////////////////////////////////////////////////////////////////////CONSTRUCTOR

  Globe(int _radius, int _sphereDetail, String _mapFilename) {
    globeRadius = _radius;
    txtMap = loadImage(_mapFilename);
    rWRatio= txtMap.width/globeRadius;
    rHRatio= txtMap.height/globeRadius;
    setTexturedSphereDetail(_sphereDetail); 
    rotation= new PVector(0, HALF_PI);
    rotSpeed= new PVector(0, 0);
  }

  ////////////////////////////////////////////////////////////////////////////METHODS

  void setTexturedSphereDetail(int detail) {   //Set the detail level for textured spheres, constructing the underlying vertex and uv map data  

    if (detail == texturedSphereDetail) { 
      return; 
    }

    texturedSphereDetail = detail; 
    float step = PI / detail; 
    float ustep = .5 / detail; 
    float vstep = 1. / detail; 
    int d1= detail+1;
    int d2= detail*2 +1;

    texturedSphereX = new float[d1][d2]; 
    texturedSphereY = new float[d1][d2]; 
    texturedSphereZ = new float[d1][d2]; 
    texturedSphereU = new float[d1][d2]; 
    texturedSphereV = new float[d1][d2]; 

    for (int i = 0; i <= detail; i++) { 
      float theta = step * i; 
      float y = cos(theta); 
      float sin_theta = sin(theta); 
      float v = 1.0f - vstep * i; 

      for (int j = 0; j <= 2 * detail; j++) { 
        float phi = step * j; 
        float x = sin_theta * cos(phi); 
        float z = sin_theta * sin(phi); 
        float u = 1.0f - ustep * j; 

        texturedSphereX[i][j] = x * globeRadius; 
        texturedSphereY[i][j] = y * globeRadius; 
        texturedSphereZ[i][j] = z * globeRadius; 
        texturedSphereU[i][j] = u * txtMap.width; 
        texturedSphereV[i][j] = v * txtMap.height;
      }
    }
  }

  void render() {  // draw the sphere
    noStroke();
    int nexti, t2= 2*texturedSphereDetail;
    //
    for (int i = 0; i < texturedSphereDetail; i=nexti) { 
      nexti = i + 1;   
      beginShape(QUAD_STRIP); 
      texture(txtMap); 
      for (int j=0; j<=t2; j++) {         
        float u  = texturedSphereU[i][j]; 
        float x1 = texturedSphereX[i][j]; 
        float y1 = texturedSphereY[i][j]; 
        float z1 = texturedSphereZ[i][j]; 
        float v1 = texturedSphereV[i][j]; 
        float x2 = texturedSphereX[nexti][j]; 
        float y2 = texturedSphereY[nexti][j]; 
        float z2 = texturedSphereZ[nexti][j]; 
        float v2 = texturedSphereV[nexti][j]; 
        vertex(x1, y1, z1, u, v1); 
        vertex(x2, y2, z2, u, v2);
      }   
      endShape();
    }
  }

  void addRotation(int mX, int mY, int pmX, int pmY) {
    rotSpeed.x += (pmY-mY)* ROTATION_FACTOR;
    rotSpeed.y -= (pmX-mX)* ROTATION_FACTOR;
  }

  void update() {
    rotation.add  (rotSpeed);
    rotSpeed.mult (.95);
  }
}