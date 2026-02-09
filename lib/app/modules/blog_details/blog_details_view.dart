import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'blog_details_logic.dart';

class BlogDetailsPage extends StatelessWidget {
  BlogDetailsPage({Key? key}) : super(key: key);

  final logic = Get.find<BlogDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: GetBuilder<BlogDetailsLogic>(builder: (logic) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titleBar(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _dateAndTimeToRead(),
                ),
          /*      Row(
                  children: List.generate(
                    logic.socialMediaData.length,
                    (index) => _socialMediaIcon(logic.socialMediaData[index]),
                  ),
                ),*/
                const SizedBox(
                  height: 14,
                ),
                Expanded(
                  child: WebViewWidget(
                    controller: logic.webViewPlusController,
                  ),
                ),
                const SizedBox(
                  height: 13,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _socialMediaIcon(SocialMedia socialMedia) {
    return InkWell(
      onTap: () async {
        Get.log("redirection link ${socialMedia.url + logic.blog.blogLink}");
        if (socialMedia.socialMediaType == SocialMediaType.whatsapp) {
          launchUrlString(socialMedia.url,
              mode: LaunchMode.externalApplication);
        } else {
          Share.share(logic.blog.blogLink);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: SvgPicture.asset(socialMedia.icon),
      ),
    );
  }

  Row _dateAndTimeToRead() {
    return Row(
      children: [
        Text(
          logic.blog.blogDate,
          style: const TextStyle(
            color: darkBlueColor,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        _seperatorLine(),
        Text(
          "${estimateReadTime(logic.blog.blogDescription)} min read",
          style: const TextStyle(
            color: darkBlueColor,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        _seperatorLine(),
        SvgPicture.asset(Res.likeIcon),
        const SizedBox(
          width: 4,
        ),
        Text(
          "2k",
          style: _seperatorTextStyle(),
        ),
      ],
    );
  }

  Row _titleBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            logic.blog.blogTitle,
            style: const TextStyle(
                color: darkBlueColor,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        InkWell(
          onTap: () {
            logic.onCloseTapped();
          },
          child: const Icon(
            Icons.clear_rounded,
            color: darkBlueColor,
          ),
        )
      ],
    );
  }

  int estimateReadTime(String content) {
    // Average reading speed in words per minute (adjust as needed)
    double wordsPerMinute = 200.0;

    // Calculate the number of words in the content
    List<String> words = content.split(RegExp(r'\s+'));
    int wordCount = words.length;

    // Calculate the estimated read time in minutes
    double readTimeMinutes = wordCount / wordsPerMinute;

    // Round up to the nearest whole minute
    int readTime = readTimeMinutes.ceil();

    return readTime;
  }

  Padding _seperatorLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        "|",
        style: _seperatorTextStyle(),
      ),
    );
  }

  TextStyle _seperatorTextStyle() {
    return const TextStyle(
      color: darkBlueColor,
      fontSize: 10,
      fontWeight: FontWeight.w400,
    );
  }
}
