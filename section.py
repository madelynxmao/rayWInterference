# find points to put in temp from new.txt given top left and bottom right point

with open('new.txt', 'r') as f:
    lines = f.readlines()
f.close()

top_left = [40.737808, -73.993356]
bottom_right = [40.734624, -73.973254]

m = len(lines)
i = 0

while i < m:

    xcor = float(lines[i].split(',')[1])
    ycor = float(lines[i].split(',')[2])

    if (xcor < float(top_left[0])) and (xcor > float(bottom_right[0])):
        if (ycor > float(top_left[1])) and (ycor < float(bottom_right[1])):
            print(lines[i], end = '')
    i = i+ 1




