# RayWInterference
This is the guide on how to run and use this program to return SNR values, open street map visual, figure with data points

## Dependencies
This program uses Matlab, cpp, and python

## Steps to run:
1. Pick a rectangular region you want to simulate. Record the upper left point and bottom left coordinates for your own reference.
2. Next, you will need to find the txlats and txlons of all the sites in that area. To do this, go to `range.cpp` and fill in the area at the top where it says `double latR[2]` and `double lonR[2]`. Make sure to 
3. Paste the result in `rayWInterference.m` in the first `%----` area.
4. Next, you will need to find the street sites. To do this, go to `section.py`, paste in your coordinate in top_left and top_right, and send the results to `temp.txt` by using `python3 section.py > temp.txt`
5. You may need to clean up `temp.txt`, meaning you have to delete the lines where the lines before AND after dont share the same first two words. 
6. Run `final.py` and paste the result in the second `%----` area in `rayWInterference.m`.
7. Paste the data from alldata.txt into `data.txt`.
8. If you may want to change the name of the file you send the result to, you can go the third `%----` area in `rayWInterference.m` and change the name of the text file. 
9. Run `rayWInterference.m`
