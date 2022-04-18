#pragma once
#include <string>

class StarData
{
	int hip;
	int hd;
	std::string glieseID;
	double ra;
	double dec;
	double dist;
	float mag;
	float absMag;
	std::string spectrum;
	float colorIndex;
	double x;
	double y;
	double z;
public:
	StarData(std::string _hip, std::string _hd, std::string _glieseID, double _ra, double _dec, double _dist, float _mag, float _absMag, std::string _spectrum, float _colorIndex, double _x, double _y, double _z);
};

