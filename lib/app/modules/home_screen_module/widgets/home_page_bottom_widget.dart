import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/financial_tool_card.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/emi_calculator/emi_screen_analytics.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/text_styles.dart';
import '../../../../res.dart';
import '../../../common_widgets/spacer_widgets.dart';
import '../../../common_widgets/shimmer_loading/skeleton_loading_widget.dart';
import '../../knowledge_base/knowledge_base_logic.dart';
import '../../knowledge_base/widgets/blog_carousel.dart';
import '../home_screen_logic.dart';
import 'our_partners.dart';

class HomePageBottomWidget extends StatelessWidget {
  HomePageBottomWidget({Key? key}) : super(key: key);

  final logic = Get.find<HomeScreenLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VerticalSpacer(40.h),
        // _blogs(),
        //  VerticalSpacer(40.h),
        OurPartners(),
        VerticalSpacer(80.h),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 24),
        //   child: Text(
        //     "Enabling India’s \nGrowth Story",
        //     style: AppTextStyles.headingLSemiBold(color: grey400),
        //   ),
        // ),
        // const VerticalSpacer(40),
      ],
    );
  }

  Widget _blogTitle() {
    return InkWell(
      onTap: logic.goToKnowledgeBase,
      child: Row(
        children: [
          Text(
            "Explore our blogs  ",
            style: AppTextStyles.headingXSMedium(color: appBarTitleColor),
          ),
          SvgPicture.asset(
            Res.exploreBlogsDoubleArrowSVG,
            height: 24.h,
          ),
        ],
      ),
    );
  }

  /*  Widget _blogs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _blogTitle(),
          const VerticalSpacer(12),
          GetBuilder<KnowledgeBaseLogic>(
            builder: (logic) {
              if (logic.isLoading) {
                return const SkeletonLoadingWidget(
                  skeletonLoadingType: SkeletonLoadingType.featuredBlog,
                );
              }
              return CarouselWithIndicator(
                onTap: blogLogic.onCardTapped,
                items: blogLogic.getFeaturedBlogs(),
              );
            },
          ),
        ],
      ),
    );
  }*/
}
