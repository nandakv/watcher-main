class LpcCalculatorModel {
  String icon;
  String title;
  String description;
  List<double> minAndMaxAmount;
  List<double> minAndMaxInterest;
  List<double> minAndMaxTenure;

  LpcCalculatorModel(
      {required this.title,required this.description, required this.icon, required this.minAndMaxAmount,required this.minAndMaxInterest,required this.minAndMaxTenure});
}
