#include <iostream>
#include <fstream>
#include <vector>
#include <iomanip>
#include <string>
#include <stdlib.h>

using namespace std;
#define FILE_NBR 5

string fileName[FILE_NBR] = {"310.csv", "311.csv", "312.csv", "313.csv", "316.csv"};
float min_lat, min_long, max_lat, max_long;

double latR[2] = {
	// 40.8044, 40.8136, // columbia university
	min_lat, max_lat, 
};

double lonR[2] = {
	// -73.9656, -73.9559, // columbia university
	 min_long, max_long, // grand central terminal
};

enum {
	ATT,
	VERIZON,
	TMOBILE,
};

#define CARRIER ATT

// MNC:
// https://en.wikipedia.org/wiki/Mobile_network_codes_in_ITU_region_3xx_(North_America)#United_States_of_America_%E2%80%93_US

class Site {
public:
	int mcc, net, area, cell;
	double lon, lat;
	Site(int _mcc, int _net, int _area, int _cell, double _lon, double _lat) {
		mcc = _mcc;
		net = _net;
		area = _area;
		cell = _cell;
		lon = _lon;
		lat = _lat;
	};
};

class MCCMNC {
public:
	int mcc, mnc;
	MCCMNC(int a, int b) {
		mcc = a, mnc = b;
	}
	
};

bool operator==(const MCCMNC& l, const MCCMNC& r) {
		return (l.mcc == r.mcc && l.mnc == r.mnc);
	}
// input format: top left lat, top left long, bottom right lat, bottom right long
int main(int argc, char const *argv[]) {
	latR[0] = atof(argv[1]);
	latR[1] = atof(argv[3]);
	lonR[0] = atof(argv[2]);
	lonR[1] = atof(argv[4]);

	string title;
	fstream fin[FILE_NBR];
	// choose file
	for (int i = 0; i < FILE_NBR; i++) {
		fin[i].open(fileName[i], ios::in);
		fin[i] >> title;
	}

	vector<Site> sites;
	char radio[10];
	int mcc, net, area, cell, unit, range, samples, change, created, updated, aveSig;
	double lon, lat;

	for (int i = 0; i < FILE_NBR; i++) {
		while (fin[i] >> title) {
			sscanf(title.c_str(), "%[^,],%d,%d,%d,%d,%d,%lf,%lf,%d,%d,%d,%d,%d,%d",
				radio, &mcc, &net, &area, &cell, &unit, &lon, &lat, &range, &samples, &change, &created, &updated, &aveSig);
			cout.precision(8);
			cout.setf(ios::fixed, ios::floatfield);
			
			//cout<<lonR[1];
			if (lon < lonR[1] && lon > lonR[0] && lat < latR[1] && lat > latR[0] && radio[0] == 'L') {
				//cout << title << endl;

				MCCMNC mc = MCCMNC(mcc, net);

				switch (CARRIER) {
					case ATT:
						if (mc == MCCMNC(310, 410) || mc == MCCMNC(313, 100))
							sites.push_back(Site(mcc, net, area, cell, lon, lat));
						break;
					case VERIZON:
						if (mc == MCCMNC(311, 480) || mc == MCCMNC(310, 12))
							sites.push_back(Site(mcc, net, area, cell, lon, lat));
						break;
					case TMOBILE:
						if (mc == MCCMNC(310, 260) || mc == MCCMNC(310, 120) || mc == MCCMNC(311, 490))
							sites.push_back(Site(mcc, net, area, cell, lon, lat));
						break;
				}
			}
		}
	}

	cout << "txLats = [";
	for (auto i = sites.begin(); i != sites.end(); i++) {
		cout << i->lat << ", ";
	}
	cout << "];" << endl << "txLons = [";
	for (auto i = sites.begin(); i != sites.end(); i++) {
		cout << i->lon << ", ";
	}
	cout << "];" << endl;
	//cout << sites.size() << endl;
	return 0;
}