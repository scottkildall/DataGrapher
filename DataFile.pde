/*******************************************************************************************************************
//
//  Class: DataFile
//
//  Written by Scott Kildall
//
//  CSV file for data plotting
//
//------------------------------------------------------------------------------------------------------------------
//
*********************************************************************************************************************/

public class DataFile {
  public DataFile() {
      
  }
  
  // 1st column is always ms, then we load data from other columns
  boolean load(String filenameToOpen) { 
    filename = new String(filenameToOpen);
    println("loading file: " + filename);
    
    loadData();    
     
    return true;
  }
  
  //-- load data from the global variable
void loadData() {  
  println("Loading data");
  
  //-- this loads the actual table into memory
  table = loadTable(filename, "header");

  // get number of rows (data items)
  numRows = (int)table.getRowCount();
  
  // store number of columns
  numColumns = (int)table.getColumnCount() - 1;
  println(numRows + " data rows in table"); 
  println(numColumns + " data columns in table"); 
  println("allocating sensor data");
  
    println("Column titles:"); 
   columnTitles = new String[numColumns];
   
   for( int i = 0; i < numColumns; i++ ) {
     TableRow row = table.getRow(0);
      columnTitles[i] = new String(row.getColumnTitle(i+1));
      println(columnTitles[i]);  // 
   }

    
   // we don't care about the 1st column (ms)
   sensorData = new float[numColumns][numRows];
   
   
  // Two nested loops allow us to visit every spot in a 2D array.   
  // change to numRows
  for (int i = 0; i < numRows; i++) {
      TableRow row = table.getRow(i);
        
        // numColumns
       for (int j = 0; j < numColumns; j++)  {
          sensorData[j][i] = row.getFloat(columnTitles[j]);
         //println(sensorData[j][i]);
       }
  }
}
 
 int getNumColumns() { 
    return numColumns;
 }  
 
 int getNumRows() { 
    return numRows;
 }  
 
   //-------- MAKES ACCESSIBLE FOR DRAWING --------/
   public float [][]sensorData;
 
  //-------- PRIVATE VARIABLES --------/
  private String filename;
  private String [] columnTitles;
  
  private int numColumns;
  private int numRows;
  private Table table;
 
  
   	
}
