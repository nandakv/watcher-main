class JobTypeQuestion {
  final String label;
  final String hint;
  final String img;
  final String title;
  final String subTitle;
  final List<String> options;
  final String selectedValue;
  final Function(String?) onChanged;

  JobTypeQuestion({
    required this.label,
    required this.hint,
    required this.img,
    required this.title,
    required this.subTitle,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });
}
