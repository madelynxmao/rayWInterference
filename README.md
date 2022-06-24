# RayWInterference
This is the guide on how to run and use this program to return SNR values, open street map visual, figure with data points

## Dependencies
This program uses Matlab, cpp, and python

## Steps to run:
0. export osm file of location you want to simulate in `export.osm`
1. run command `python3 -u trial.py -i range2 > rayWInterference.m`
2. run `rayWInterference.m` with Matlab


## Side effects
0. Creates temp.txt to store street names with lat and long
1. Creates alldata.txt which the matlab file needs to run
2. The matlab program, when run with matlab, will create a text file with the SNR values called `section.txt`
3. The matlab program will also launch a visual representation of the strength of the SNR
