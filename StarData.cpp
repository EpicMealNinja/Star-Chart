#include "StarData.h"

StarData::StarData(std::string _hip, std::string _hd, std::string _glieseID, double _ra, double _dec, double _dist, float _mag, float _absMag, std::string _spectrum, float _colorIndex, double _x, double _y, double _z)
{
	if (_hip != "")
		hip = stoi(_hip);
	if (_hd != "")
		hd = stoi(_hd);
	glieseID = _glieseID;
	ra = _ra;
	dec = _dec;
	dist = _dist;
	mag = _mag;
	absMag = _absMag;
	spectrum = _spectrum;
	colorIndex = _colorIndex;
	x = _x;
	y = _y;
	z = _z;
}
