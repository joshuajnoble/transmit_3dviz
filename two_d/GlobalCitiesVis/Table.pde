//Table///////////////////////////////almost classic class, extracted from Ben Fry's "Visualizing Data"
//////////////////////////////////////////////////////////////////////////////////////////////////////

class Table {
  String[][] data;
  int numRows, numCols;

  //CONSTRUCTOR
  Table(String nombre) {   
    String[] filas = loadStrings(nombre); 
    numRows = filas.length;
    data = new String[numRows][];
    for (int i = 0; i < filas.length; i++) {
      if (trim(filas[i]).length() == 0) {
        continue;
      }   
      if (filas[i].startsWith("#")) {      //startsWith() doesn't work on processingjs
        continue;
      }   
      data[i] = split(filas[i], ",");       //dont use TAB on processingjs
    }       
    numCols=data[0].length;
  }

  //METHODS

  //Returns number of rows
  int getNumRows() { 
    return numRows;
  }

  //Return number of cols
  int getNumCols() { 
    return numCols;
  }

  //Returns name of a row, specified by index
  String getRowName(int rowIndex) { 
    return getString(rowIndex, 0);
  }

  //Returns value as String | be careful with method overloading using processingjs
  //String getString(String rowName, int col) { return getString(getRowIndex(rowName),col); }
  String getString(int rowIndex, int colIndex) { 
    return data[rowIndex][colIndex];
  }

  //Returns value as Int | be careful, bla, bla..
  //int getInt(String rowName, int col) { return parseInt(getString(rowName,col));}   
  int getInt(int rowIndex, int colIndex) { 
    return parseInt(getString(rowIndex, colIndex));
  }

  //Returns value as Float | be careful, bla, bla..
  //float getFloat(String rowName, int col) { return parseFloat(getString(rowName,col)); }
  float getFloat(int rowIndex, int colIndex) { 
    return parseFloat(getString(rowIndex, colIndex));
  }

  //Find file by its name and returns -1 in case of failure
  int getRowIndex(String name) {
    for (int i = 0; i < numRows; i++) {
      if (data[i][0].equals(name)) {
        return i;
      }
    }
    println("I didn't found any row called '"+ name+"!'");
    return -1;
  }

  //Returns the sum of all the values in a row, specified by index
  int rowSum (int index) {
    int sum=0;
    for (int i=1; i<numCols; i++) {
      sum+=getInt(index, i);
    }
    return sum;
  }

  //Returns the sum of all the values in a column, specified by index
  int colSum (int index) {
    int sum=0;
    for (int i=1; i<numRows; i++) {
      sum+=getInt(i, index);
    } 
    return sum;
  }

  //Returns the row with maximum value sum
  int maxRowSum() { 
    int maxSum=0;  
    for (int i=1; i<numRows; i++) {
      if (rowSum(i)>=maxSum) {
        maxSum=rowSum(i);
      }
    }
    return maxSum;
  }

  //Returns the total sum of all the values in the table
  int totalSum() {
    int sum=0;  
    for (int i=1; i<numRows; i++) {
      sum+=rowSum(i);
    } 
    return sum;
  }
} 