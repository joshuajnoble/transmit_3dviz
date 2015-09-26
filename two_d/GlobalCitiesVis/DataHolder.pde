final float MIN_TO_DEG= 1/60f;     
final float SEG_TO_DEG= 1/3600f;
//final float SCALE_F= 3e-6;
final float SCALE_F= Float.MIN_VALUE;

class DataHolder
{

  String name, country;
  int value, index;
  float latitude, longitude;
  PVector startVector, endVector;
  boolean hovered=false;

  DataHolder (int i) {
    index     = i+1;  
    name      = t.getString (i+1, 0);
    country   = t.getString (i+1, 1);
    value     = t.getInt    (i+1, 2);
    latitude  = parseCoord  (t.getString(i+1, 3));
    longitude = parseCoord  (t.getString(i+1, 4));
    startVector     = polarToCartesian (latitude, longitude, -1);
    //endVector       = polarToCartesian (latitude, longitude, value*SCALE_F);
    endVector       = polarToCartesian (latitude, longitude, 1);
  }

  //A custom method to parse Geonames´s database coordinates 
  float parseCoord(String a) {
    //Split the string using whitespace characters as delimiters.
    String[] c= split(a, " ");
    //Match a regular expresion in order to exclude any symbol
    for (int i=1; i<c.length; i++) c[i]= match(c[i], "\\d++")[0]; 
    //Transform the coordinates into a single floating value
    float coord= int(c[1]) + int(c[2])*MIN_TO_DEG + int(c[3]) * SEG_TO_DEG; 
    //And check orientation: if first char is 'S' or 'W' set a negative sign
    char orientation=c[0].charAt(0);
    if  (orientation==87 || orientation==83) {
      coord*=-DEG_TO_RAD; 
    } else { 
      coord*=DEG_TO_RAD;
    }
    return coord;
  }

  void setHoveredTo (boolean booleanToSet) {
    hovered= booleanToSet;
  }

  // returns a Pvector representing the lat, long and altitude in 3d space
  // altitude is relative to the surface of the globe
  PVector polarToCartesian(float lat, float lng, float hght) {
    float shift_lat = lat + HALF_PI;                     // shift the lat by 90 degrees
    float tot_hght  = w.globeRadius + hght;

    float x = -tot_hght * sin(shift_lat) * cos(lng);     // -1 needed cause of the orientation of the processing 3d cartesian coordinate system
    float z =  tot_hght * sin(shift_lat) * sin(lng);
    float y =  tot_hght * cos(shift_lat);
    return  new PVector(x, y, z);
  }

  void renderBox(Globe globe, int centerX, int centerY) {    
    
    
    //PVector globeCenter = new PVector(centerX/2, centerY/2, globe.globeRadius);
    PVector globeCenter = new PVector(centerX/2, centerY/2, 0);
    PVector up = new PVector( 0, 1, 0);
    
    PVector direction = new PVector();
    direction.set(endVector);
    direction.normalize();
    
    PVector axis = up.cross(direction);
    axis.normalize();
    
    PVector angleVec = up;
    float angle = acos(angleVec.dot(direction));
    
    noStroke();
    pushMatrix();
    translate(endVector.x, endVector.y, endVector.z);
    
    rotate( angle, axis.x, axis.y, axis.z);

    box(10, value/100000, 10);
    //canvas.sphere(10);
    popMatrix();
  }
}
