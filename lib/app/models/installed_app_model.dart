class InstalledAppModel {
  final String name;
  final List<int> icon;
  final String packageName;

  static InstalledAppModel fromMap(Map data) {
    return InstalledAppModel(
      name: data['name'],
      icon: data['icon'],
      packageName: data['packageName'],
    );
  }

  InstalledAppModel(
      {required this.name, required this.icon, required this.packageName});
}
