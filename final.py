from ctypes import sizeof
from dis import dis
from math import sin, cos, sqrt, atan2, radians

# PUT DATA WITH STREET NAMES IN TEMP.TXT
# THIS PROGRAM PRINTS WHAT SHOULD GO IN MATLAB FILE ie rxRange = lineNbr = ...
# DATA.TXT IN MATLAB SHOULD BE UPDATED WITH THE CONTENTS OF ALLDATA.TXT

with open('temp.txt', 'r') as f:
    lines = f.readlines()
f.close()

curr_first = lines[0].split()[0]
curr_second = lines[0].split()[1]

m = len(lines)
i = 0

open("alldata.txt", "w").close() #clears alldata.txt first
alldata = open("alldata.txt", "a")
while i < m:
    unsorted = []
    ## get the bundle of streets/ ave
    while lines[i].split()[0] == curr_first and lines[i].split()[1] == curr_second:
        data=[e.strip() for e in lines[i].split(',')]
        #print(data[0] + "," + data[1] + "," + data[2])
        i = i + 1

        new_unsorted_element = (float(data[1]), float(data[2]))
        unsorted.append(new_unsorted_element)

        if i >= m:
            break

    #sort by lat or long
    
    a1 = min(unsorted)[0]
    a2 = max(unsorted)[0]
    b1 = min(unsorted, key = lambda t: t[1])[1]
    b2 = max(unsorted, key = lambda t: t[1])[1]

    fsorted = []
    if abs(a1-a2) > abs(b1-b2):
        fsorted = sorted(unsorted)
    else:
        fsorted = sorted(unsorted, key=lambda a:a[1])
    
    rxRange = []
    for j in range(len(fsorted) - 1):
        toadd = [fsorted[j][0], fsorted[j][1], fsorted[j+1][0], fsorted[j+1][1]]
        rxRange.append(toadd)
        toaddinfile = str(toadd[0]) + "\t" + str(toadd[1]) + "\t" + str(toadd[2]) + "\t" + str(toadd[3])
        alldata.write(toaddinfile + "\n")
    
    if i >= m:
        alldata.close()
        break
    curr_first = lines[i + 1].split()[0]
    print(curr_first)
    curr_second = lines[i + 1].split()[1]

count = 0
dist = []
numpoints = []
with open('alldata.txt', 'r') as f2:
    lines = f2.readlines()
    lineNbr = len(lines)
for i in lines:

    data=[e.strip() for e in i.split('\t')]

    lat1, lon1, lat2, lon2 = radians(float(data[0])), radians(float(data[1])), radians(float(data[2])), radians(float(data[3]))
    # approximate radius of earth in km
    R = 6373.0

    dlon = lon2 - lon1
    dlat = lat2 - lat1

    a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2
    c = 2 * atan2(sqrt(a), sqrt(1 - a))

    distance = int(round(R * c * 1000))
    points = int(round(distance / 10))

    dist.append(distance)
    numpoints.append(points)

    count = count + 1

print("dont forget ;")
print("lineNbr = ", lineNbr, ";")
print("rxNbr = ", numpoints, ";")
print("rxSpanDis = ", dist, ";")

f2.close()

