import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

import 'design_system_data_entry_screen.dart';
import 'widgets/data_display.dart';
import 'widgets/foundation_content.dart';

import 'design_system_components_logic.dart';
import 'design_system_feedback_components_view.dart';

class DesignSystemComponentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const VerticalSpacer(24),
              SvgPicture.asset(Res.csIndiaLogo),
              const VerticalSpacer(8),
              Text(
                'Design System Components'.toUpperCase(),
                style: const TextStyle(
                    color: darkBlueColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
              const VerticalSpacer(24),
              const TabBar(
                tabs: [
                  Tab(text: 'Foundation'),
                  Tab(text: 'Data Display'),
                  Tab(text: 'Data Entry'),
                  Tab(text: 'Data Feedback'),
                ],
               isScrollable: true,
                tabAlignment: TabAlignment.start,
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    FoundationContent(),
                    DataDisplay(),
                    DesignSystemDataEntryScreen(),
                DesignSystemFeedBackView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
