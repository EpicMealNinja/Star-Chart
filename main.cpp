#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <unordered_map>
#include "StarData.h"

void mergeSort(std::vector<std::pair<double, int>>& v, int start, int end);
void merge(std::vector<std::pair<double, int>>& v, int start, int mid, int end);

int main() {
	//Create the file input that will take in all the data from the data set of stars
	std::ifstream hygData("hygdata_v3.csv");

	//This is the map that will store the reference to each star
	std::vector <StarData> data;

	//This is the vector that will be used to determine what stars are rendered on the screen.
	std::vector<std::pair<double, int>> starDist;

	//This will take in and throw away the header line in the csv file.
	std::string throwAway;
	std::getline(hygData, throwAway);

	std::string id;
	while (std::getline(hygData, id, ',')) {
		//These variables will handle all the data collection that needs to be handled for the class
		std::string hip;
		std::getline(hygData, hip, ',');

		std::string hd;
		std::getline(hygData, hd, ',');

		std::getline(hygData, throwAway, ',');

		std::string glieseID;
		std::getline(hygData, glieseID, ',');

		std::getline(hygData, throwAway, ',');
		std::getline(hygData, throwAway, ',');

		std::string ra;
		std::getline(hygData, ra, ',');

		std::string dec;
		std::getline(hygData, dec, ',');

		std::string dist;
		std::getline(hygData, dist, ',');

		std::getline(hygData, throwAway, ',');
		std::getline(hygData, throwAway, ',');
		std::getline(hygData, throwAway, ',');

		std::string mag;
		std::getline(hygData, mag, ',');

		std::string absMag;
		std::getline(hygData, absMag, ',');

		std::string spectrum;
		std::getline(hygData, spectrum, ',');

		std::string colorIndex;
		std::getline(hygData, colorIndex, ',');

		std::string x;
		std::getline(hygData, x, ',');

		std::string y;
		std::getline(hygData, y, ',');

		std::string z;
		std::getline(hygData, z, ',');

		std::getline(hygData, throwAway);

		if (colorIndex == "")
			colorIndex = "0";

		//Create the star data object to be emplaced with the identifier
		StarData currentStar(hip, hd, glieseID, std::stod(ra), std::stod(dec), std::stod(dist), std::stof(mag), std::stof(absMag), spectrum, std::stof(colorIndex), std::stod(x), std::stod(y), std::stod(z));

		//Emplace the identifier and the data that goes along with it in the class
		data.push_back(currentStar);

		//This will place in all the star distances for easy access
		starDist.push_back({ std::stod(dist), stoi(id) });
	}

	mergeSort(starDist, 0, starDist.size() - 1);
}

void mergeSort(std::vector<std::pair<double, int>>& v, int start, int end)
{
	if (start < end)
	{
		//Mid is the point where the vector will be divided into two sub vectors
		int mid = start + (end - start) / 2;

		mergeSort(v, start, mid);

		mergeSort(v, mid + 1, end);

		//Merging the two sorted sub vectors back together
		merge(v, start, mid, end);
	}
}

void merge(std::vector<std::pair<double, int>>& v, int start, int mid, int end)
{
	//temporarily store the vector that is obtained when elements are merged from
	//[start to end] and [mid + 1 to end]
	std::vector<std::pair<double, int>> temp;
	int i, j;

	i = start; //Index for first half  i <-- first half from start to mid

	j = mid + 1; //Index for second half j <-- second half from mid + 1 to end

		//While there are elements in both sub vectors, add them to temporary vector
	while (i <= mid && j <= end)
	{
		if (v[i].first <= v[j].first)
		{
			temp.push_back(std::make_pair(v[i].first, v[i].second));
			++i;
		}

		else
		{
			temp.push_back(std::make_pair(v[j].first, v[j].second));
			++j;
		}
	}

	//When we run out of elements in second half but elements still exist in first half, add the first half of elements into temporary vector
	while (i <= mid)
	{
		temp.push_back(std::make_pair(v[i].first, v[i].second));
		++i;
	}

	//When we run out of elements in first half but elements still exist in second half, add the second half elements into temporary vector
	while (j <= end)
	{
		temp.push_back(std::make_pair(v[j].first, v[j].second));
		++j;
	}
	//Copy all the elements of temporary vector into main vector
	for (int i = start; i <= end; ++i)
	{
		v[i] = temp[i - start];
	}
}
