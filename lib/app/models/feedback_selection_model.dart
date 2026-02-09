
class Reason {
  String name;
  bool isChecked;

  Reason({required this.name, this.isChecked = false});
}

class FeedbackSuggestion {
  String header;
  List<Reason> items;
  bool isExpanded;

  FeedbackSuggestion({
    required this.header,
    required this.items,
    this.isExpanded = false,
  });
}
