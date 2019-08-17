# DataGrapher
Processing sketch to graph point data from a .csv file

by [Scott Kildall](https://kildall.com/) 


## Format
Will draw data from a .csv file
  First column (field) is always ignored, then the next columns are drawn
  
  Data is in range of 0.0 to 1.0
  This can be changed with the lowerSampleRange and upperSampleRange variables
  
  Supports up to 4 columns of data at a time, but this can also be easily
  expanded to add more
 
 CSV file looks something like:
 
  ms,sensor1,sensor2
  
  0,0.821,0.802
 
 1011,0.823,0.797
  
  2023,0.816,0.803
  
  3034,0.819,0.802
  
  4045,0.824,0.793
  
  
## To be added
Number of files and filenames to be read from the data directory. Currently this is hard-coded


  
  