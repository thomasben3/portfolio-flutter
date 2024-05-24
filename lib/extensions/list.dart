extension ListDouble on List<double> {
  double get sum {
    double total = 0;
    
    for (double d in this) {
      total += d;
    }
    return total;
  }
}