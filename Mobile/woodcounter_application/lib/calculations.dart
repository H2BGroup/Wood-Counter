const plateAreaInMM = 1161;

double calculateStackVolume(int stackArea, int plateArea, double stackLength)
{
  int fullStackArea = stackArea + plateArea;
  double rate = plateAreaInMM / plateArea;

  return (fullStackArea * rate * stackLength * 1000) / 1000000000;
}
