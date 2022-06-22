from tokenize import Double
import xml.etree.ElementTree as ET

def get_intersections(osm):
    """
    This method reads the passed osm file (xml) and finds intersections (nodes that are shared by two or more roads)

    :param osm: An osm file or a string from get_osm()
    """
    intersection_coordinates = []
    tree = ET.parse(osm)
    root = tree.getroot()
    children = list(root)

    counter = {}
    for child in children:
        if child.tag == 'way':
            # Check if the way represents a "highway (road)"
            road = False
            road_types = {'primary', 'secondary', 'residential', 'tertiary', 'service', 'unclassified', 'primary_link', 'secondary_link', 'tertiary_link', 'service'}
            for item in child:
                if item.tag == 'tag' and item.attrib['k'] == 'highway' and item.attrib['v'] in road_types: 
                    road = True

            if not road:
                continue

            for item in child:
                if item.tag == 'nd':
                    nd_ref = item.attrib['ref']
                    if not nd_ref in counter:
                        counter[nd_ref] = 0
                    counter[nd_ref] += 1

    # Find nodes that are shared with more than one way, which might correspond to intersections
    intersections = {k for k, v in counter.items() if v > 1}

    # Extract intersection coordinates
    # You can plot the result using this url.
    # http://www.darrinward.com/lat-long/
    nodeIds = []
    for child in children:
        if child.tag == 'node' and child.attrib['id'] in intersections:
            coordinate = [float(child.attrib['lat']),float(child.attrib['lon'])]
            nodeIds.append(child.attrib['id'])
            intersection_coordinates.append(coordinate)
    #return intersection_coordinates

    # getting the street names 
    # given a list of nodes numbers
    # ['42432068', '42432071', '42432073', '42432075', '42437074', '42437078', '42437082', '42437084', '3670609093']

    # final return: street 1, street 2, lat, long
    # street 1 and street 2 ordered alphabetically
    intersecount = 0
    final = []
    curr = []
    yes = 0
    for node in nodeIds:
        curr = []
        for child in children:
            if child.tag == 'way':
                for item in child:
                    if item.tag == 'nd' and item.attrib['ref'] == str(node):
                        #print("item", item.attrib['ref'])
                        temp = child.attrib['id']
                        #print("id", child.attrib['id'])
                        yes = 1
                    if yes == 1:
                        if item.tag == 'tag':
                            if item.attrib['k'] == 'name' and child.attrib['id'] == temp: 
                                #print("v: ", item.attrib['v']) 
                                curr.append(item.attrib['v'])
                                #print("c", child.attrib['id']) 
        curr = list(set(curr))  
        if len(curr) == 2:

            dest = [curr[0], curr[1]]
            dest.sort()
            toadd_dest = dest[0] + ' and ' + dest[1]

            temp = [toadd_dest, intersection_coordinates[intersecount][0],intersection_coordinates[intersecount][1]]
            
            intersecount = intersecount + 1
            final.append(temp)
                         
    final.sort()

    for i in final:
        print( str(i[0]) + ',' + str(i[1]) + ',' + str(i[2]))

get_intersections('export.osm')
