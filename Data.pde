  public class StarInfo {
    int id;
    int hip;
    int hd;
    String gl;
    double ra;
    double dec;
    double dist;
    float mag;
    float absmag;
    String spect;
    Float ci;
    double x;
    double y;
    double z;
  }


public class Data {
  Table table;
  BufferedReader reader;

  ArrayList<StarInfo> starData = new ArrayList<StarInfo>();
  ArrayList<Pair<Double, Integer>> starDist = new ArrayList<Pair<Double, Integer>>();
  //double is distance, integer is the id;

  void loadData() {
    table = loadTable("hygdata_v3.csv", "header");

    for (TableRow row : table.rows()) {
      StarInfo star = new StarInfo();

      star.id = row.getInt("id");
      star.hip = row.getInt("hip");
      star.hd = row.getInt("hd");
      star.gl = row.getString("gl");
      star.ra = row.getDouble("ra");
      star.dec = row.getDouble("dec");
      star.dist = row.getDouble("dist");
      star.mag = row.getFloat("mag");
      star.absmag = row.getFloat("absmag");
      star.spect = row.getString("spect");
      star.ci = row.getFloat("ci");
      star.x = row.getDouble("x");
      star.y = row.getDouble("x");
      star.z = row.getDouble("x");

      starDist.add(new Pair<Double, Integer>(star.dist, star.id));
      starData.add(star);
    }
    mergeSort(0, starDist.size() - 1);
  }

  void mergeSort(int start, int end) {
    if (start < end) {
      //Mid is the point where the array will be divided into two sub arrays
      int mid = start + (end - start) / 2;
      mergeSort(start, mid);
      mergeSort(mid + 1, end);

      //Merging the two sorted sub arrays back together
      merge(start, mid, end);
    }
  }
  //ArrayList<Pair<Double, Integer>> temp = new ArrayList<Pair<Double, Integer>>();

  void merge(int start, int mid, int end) {

    int n1 = mid - start + 1;
    int n2 = end - mid;

    ArrayList<Pair<Double, Integer>> L = new ArrayList<Pair<Double, Integer>>();
    ArrayList<Pair<Double, Integer>> R = new ArrayList<Pair<Double, Integer>>();

    for (int i = 0; i < n1; ++i)
      L.add(starDist.get(start + i));
    for (int j = 0; j < n2; ++j)
      R.add(starDist.get(mid + 1 + j));

    int i = 0, j = 0;

    int k = start;

    while (i < n1 && j < n2) {
      if (L.get(i).getKey() <= (R.get(j)).getKey()) {
        starDist.set(k, L.get(i));
        i++;
      } else {
        starDist.set(k, R.get(j));
        j++;
      }
      k++;
    }

    while (i < n1) {
      starDist.set(k, L.get(i));
      i++;
      k++;
    }

    while (j < n2) {
      starDist.set(k, R.get(j));
      j++;
      k++;
    }
  }

  /*
****************************CONSTELLATIONS*********************************
   */
  public class ConstellationInfo {
    Map<Integer, ArrayList<Integer>> adjList = new HashMap<Integer, ArrayList<Integer>>();

    void addEdge(int first, int second)
    {
      addStar(first);
      addStar(second);
      adjList.get(first).add(second);
      adjList.get(second).add(first);
    }

    void addStar(int star)
    {
      if (!adjList.containsKey(star)) {
        ArrayList<Integer> empty= new ArrayList<Integer>();
        adjList.put(star, empty);
      }
    }
  }
  Map<String, ConstellationInfo> constellations = new HashMap<String, ConstellationInfo>();

  void loadConData()
  {
    reader = createReader("Constellations.txt");
    String line[];
    try {
      for (int i = 0; i < 20; i++) {
        line = reader.readLine().split(",");

        String conName;
        int first;
        int second = -1;

        conName = line[0];
        ConstellationInfo temp = new ConstellationInfo();
        constellations.put(conName, temp);

        for (int j = 1; j < line.length; j++) {
          int space = line[j].indexOf(" ");

          if (space != -1) {
            first = Integer.parseInt(line[j].substring(0, space));
            second = Integer.parseInt(line[j].substring(space + 1, line[j].length()));
          } else {
            first = Integer.parseInt(line[j]);
          }

          if (second == -1) {
            constellations.get(conName).addStar(first);
          } else {
            constellations.get(conName).addEdge(first, second);
          }
        }
      }
    }
    catch(IOException e) {
      e.printStackTrace();
    }
  }
  
}
