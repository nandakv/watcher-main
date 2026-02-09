import 'package:privo/res.dart';

class UserInteractionModel {
  String url;
  String img;
  String interactionTimeInfo;
  String title;
  bool isYoutubeLink;

  UserInteractionModel({
    required this.url,
    this.img = Res.youtubeThumbnail,
    required this.title,
    required this.interactionTimeInfo,
    this.isYoutubeLink = false,
  });
}
