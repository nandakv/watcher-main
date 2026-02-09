class PrivoAppBarModel {
  String title;
  double progress;
  String subTitle;
  bool isAppBarVisible;
  bool isTitleVisible;
  String appBarText;
  Function? onClosePressed;

  PrivoAppBarModel({
    required this.title,
    required this.progress,
    this.subTitle = "",
    this.appBarText = "",
    this.isAppBarVisible = true,
    this.isTitleVisible = true,
    this.onClosePressed,
  });
}
