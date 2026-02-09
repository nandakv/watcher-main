class HtmlTextModel {
  final String text;
  final HtmlTextFormat format;

  HtmlTextModel({required this.text, required this.format});

  Map<String, dynamic> toJson() => {'text': text, 'format': format};

  @override
  String toString() => toJson().toString();
}

enum HtmlTextFormat { normal, bold, italic, underline, h1 }