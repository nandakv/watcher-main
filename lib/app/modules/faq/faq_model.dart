class FAQModel {
  final String attribute;
  final List<FAQ> faqs;

  FAQModel({required this.faqs, required this.attribute});
}

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}
