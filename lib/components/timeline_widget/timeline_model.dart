class TimelineModel {
  final String icon;
  final String title;
  final String subtitle;
  final Function()? onInfoTapped;

  const TimelineModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onInfoTapped,
  });
}
