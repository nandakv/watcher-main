class SearchResult {
  String companyName;
  bool manual;

  SearchResult({required this.companyName, this.manual = false});

  @override
  String toString() {
    return "companyName - $companyName, manual - $manual";
  }
}
