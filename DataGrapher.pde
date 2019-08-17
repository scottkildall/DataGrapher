/*
  DataGrapher
  Written by Scott Kildall
  August 2019
  
  Will draw data from a .csv file
  First column (field) is always ignored, then the next columns are drawn
  
  Data is in range of 0.0 to 1.0
  This can be changed with the lowerSampleRange and upperSampleRange variables
  
  Supports up to 4 columns of data at a time, but this can also be easily
  expanded to add more
  
  ms,sensor1,sensor2
  0,0.821,0.802
  1011,0.823,0.797
  2023,0.816,0.803
  3034,0.819,0.802
  4045,0.824,0.793
  
*/

// All data files we will busing
DataFile [] dataFiles;


Table table;          //-- this is our table of data
int numColumns = 1;    // just support 1-data entry for now

int graphWidth;
int graphHeight;
int graphHMargin = 50;
int graphVMargin = 25;
int numCollectedSamples = 0;     // when = graphWidth, then we begin circular bugger
int nextOffset = 0;        // circular buffer

float lowerSampleRange = 0.0;
float upperSampleRange = 1.0;
float lastSample = .5;

// simulator
Timer sensorTimer;

// Serial poirt stuff
import processing.serial.*;

Serial myPort;  // Create object from Serial class
int serialPortNum = 1;    // this will change depending on your computer configuration
boolean bProcessDigits = false;
int analogValue = 0;
int lastAnalogValue = 0;

// how many fields we will draw, currenly this is FOUR, but it can be more
int numDrawDataColumns = 4;
boolean[] drawDataColumn = new boolean[numDrawDataColumns];

// number of data files we are using
int numDataFiles = 4;
int currentDataFile = 0;    
 
void setup() 
{
  size(1200,600);
  
  graphWidth = width - (graphHMargin*2);
  graphHeight = height - (graphVMargin*2);
  
  // Allocate DataFiles and load the data
  dataFiles = new DataFile[numDataFiles];
  dataFiles[0] = new DataFile();
  dataFiles[1] = new DataFile();
  dataFiles[2] = new DataFile();
  dataFiles[3] = new DataFile();
  
  // hardcoded filenames, for testing — this is various sensor data
  dataFiles[0].load("data/anaconda.csv");
  dataFiles[1].load("data/gecko.csv");
  dataFiles[2].load("data/08042019_sochariver.csv");
  dataFiles[3].load("data/PIF_treedata.csv");

  // flags to draw data or not
   for (int i = 0; i < numColumns; i++ )
    drawDataColumn[i] = true;
    
   
   // debug output
   int numRows =  dataFiles[currentDataFile].getNumRows();
   outputSamples(dataFiles[currentDataFile].sensorData[1], 5000);
}

void draw() {
  background(0);
  

  drawAxes();
  plotData();
  
  fill(255);
  text(str(lastAnalogValue), graphHMargin, height - graphVMargin + 20);
}

void keyPressed() {
   // support 1-4
   if( key >= '1' && key <= '4' ) {
     int keyVal = key - '1';
     drawDataColumn[keyVal] = !drawDataColumn[keyVal];
     println("toggling drawDataColumn: " + keyVal );
   }
   
   // left - right arrow keys to switch between graphs
  if (key == CODED) {
    if (keyCode == LEFT) {
      currentDataFile--;
      if( currentDataFile < 0 )
        currentDataFile = numDataFiles;
    }
    else if (keyCode == RIGHT) {
      currentDataFile++;
      if( currentDataFile == numDataFiles )
        currentDataFile = 0;
    }
  }
}

// draws axes of the graph
void drawAxes() {
  fill(128);
  stroke(128);
  strokeWeight(1);
  
  line( graphHMargin, height - graphVMargin, graphHMargin + graphWidth, height - graphVMargin);
  line( graphHMargin, height - graphVMargin, graphHMargin, height - graphVMargin - graphHeight);
}

void plotData() {
   int numPlots = dataFiles[currentDataFile].getNumColumns();
   int numRows =  dataFiles[currentDataFile].getNumRows();
  // do plotting based on 1-4 values

  for( int i = 0; i< numPlots; i++ ) {
    if( drawDataColumn[i] ) {
      setGraphColor(i);
      drawSamples(dataFiles[currentDataFile].sensorData[i], numRows);
    }
  }
}

// index 0-3, different colors
void setGraphColor(int index) {
   if( index == 0 ) 
     stroke(0,255,0);
   else if( index == 1 ) 
     stroke(255,255,0);
   else if( index == 2 ) 
     stroke(255,0,0);
   else if( index == 3 ) 
     stroke(0,255,255);
    else
     stroke(255,255,255);
}

void outputSamples( float [] sensorData, int numData ) { 
  println("sample values:");
  
  for( int i = 0; i < numData; i++ )
    println(sensorData[i]);
}

// normalized to drawing points  — make int a 2D array 
void drawSamples( float [] sensorData, int numData ) { 
  if( numData < graphWidth ) { 
    for( int i = 0; i < numData; i++ ) {
      float drawY = map( sensorData[i], lowerSampleRange, upperSampleRange, graphHeight + graphVMargin -1, 0 + graphVMargin );
      point( graphHMargin + i, drawY );
    }
  }
  else {
    int skipAmount = numData/graphWidth;
    int j = nextOffset;
   for( int i = 0; i < graphWidth; i++ ) {
      float drawY = map( sensorData[j], lowerSampleRange, upperSampleRange, graphHeight + graphVMargin - 1, 0 + graphVMargin );
      
      j += skipAmount;
      if( j >= numData )
        break;
       
      
      point( graphHMargin + i, drawY );
    } 
  }
}
