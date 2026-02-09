import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/models/privo_blogs.dart';
import 'package:privo/app/modules/knowledge_base/knowledge_base_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Function() onTap;

  BlogCard({Key? key, required this.blog, required this.onTap})
      : super(key: key);

  final logic = Get.find<KnowledgeBaseLogic>();

  @override
  Widget build(BuildContext context) {
    return _blogCard(blog);
  }

  Widget _blogCard(Blog blog) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          border: Border.all(color: darkBlueColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(7),
                    bottomLeft: Radius.circular(7),
                  ),
                  child: Image.network(
                    blog.blogImage,
                    fit: BoxFit.cover,
                    height: 100.h,
                  )),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _blogCardDetails(blog),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _blogCardDetails(Blog blog) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            blog.blogTitle,
            style: _titleTextStyle(),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                blog.blogDate,
                style: _blogDateTextStyle(),
              ),
              _seperatorLine(),
              Text(
                "${estimateReadTime(blog.blogDescription)} min read",
                style: _blogDateTextStyle(),
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
          )
        ],
      ),
    );
  }

  TextStyle _blogDateTextStyle() {
    return const TextStyle(
      color: darkBlueColor,
      fontSize: 8,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle _titleTextStyle() {
    return const TextStyle(
      color: darkBlueColor,
      fontSize: 12,
      fontWeight: FontWeight.w600,
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
    return _blogDateTextStyle();
  }
}
