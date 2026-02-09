import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/modules/knowledge_base/widgets/blog_card.dart';
import 'package:privo/app/modules/navigation_drawer/navigation_drawer_view.dart';
import 'package:privo/app/modules/on_boarding/widgets/privo_app_bar/app_bar_bottom_divider.dart';
import 'package:privo/app/modules/polling/gradient_circular_progress_indicator.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'knowledge_base_logic.dart';
import 'widgets/blog_carousel.dart';

class KnowledgeBasePage extends StatelessWidget {
  KnowledgeBasePage({Key? key}) : super(key: key);

  final logic = Get.find<KnowledgeBaseLogic>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: logic.onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: logic.homePageScaffoldKey,
        drawer: const NavigationDrawerPage(
          rowIndex: 3,
          key: Key("knowledge_base"),
        ),
        appBar: _knowledgeBaseAppBar(),
        body: Column(
          children: [
            const AppBarBottomDivider(),
            Expanded(
              child: GetBuilder<KnowledgeBaseLogic>(builder: (logic) {
                return SingleChildScrollView(
                  child: Column(
                    children: [logic.isLoading ? _onLoading() : showBlogs()],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Padding _onLoading() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 100),
      child: RotationTransitionWidget(
        loadingState: LoadingState.progressLoader,
        buttonTheme: AppButtonTheme.dark,
      ),
    );
  }

  AppBar _knowledgeBaseAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        "Knowledge Base",
        style: appBarTextStyle,
      ),
      elevation: 0,
      centerTitle: false,
      shadowColor: const Color(0xFF3B3B3E1A),
      titleSpacing: -2,
      leading: InkWell(
        child: SvgPicture.asset(Res.hamburger),
        onTap: () {
          logic.openDrawer();
        },
      ),
    );
  }

  Widget showBlogs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CarouselWithIndicator(
            onTap: logic.onCardTapped,
            items: logic.getFeaturedBlogs(),
          ),
          const SizedBox(
            height: 24,
          ),
          _recentBlogsHeader(),
          ..._showBlogCards(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: InkWell(
              onTap: _onViewAllClicked,
              child: const Text(
                "View all",
                style: TextStyle(
                  color: darkBlueColor,
                  fontSize: 10,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onViewAllClicked() {
    launchUrlString("https://creditsaison.in/blog",
        mode: LaunchMode.externalApplication);
  }

  List<Widget> _showBlogCards() {
    return List.generate(
      _computeNumberOfBlogs(),
      (index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: BlogCard(
            blog: logic.listOfBlogs.listOfBlogs[index],
            onTap: () {
              logic.onBlogTapped(index);
            }),
      ),
    );
  }

  int _computeNumberOfBlogs() {
    if (logic.listOfBlogs.listOfBlogs.length >= 3) {
      return 3;
    }
    return logic.listOfBlogs.listOfBlogs.length;
  }

  Row _recentBlogsHeader() {
    return Row(
      children: [
        Text(
          "Recent Blogs",
          style: _recentBlogsTextStyle(),
        ),
        const SizedBox(
          width: 8,
        ),
        Container(
          decoration: _blogCountDecoration(),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(
            "10",
            style: _blogCountTextStyle(),
          ),
        )
      ],
    );
  }

  TextStyle _recentBlogsTextStyle() {
    return const TextStyle(
      color: darkBlueColor,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle _blogCountTextStyle() {
    return const TextStyle(
        color: Color(0xFFFFF3EB), fontSize: 8, fontWeight: FontWeight.w600);
  }

  BoxDecoration _blogCountDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(8), color: const Color(0xFFAF8E2F));
  }

  TextStyle get appBarTextStyle => GoogleFonts.poppins(
        fontSize: 14,
        color: const Color(0xFF161742),
        letterSpacing: 0.11,
        fontWeight: FontWeight.w500,
      );
}
