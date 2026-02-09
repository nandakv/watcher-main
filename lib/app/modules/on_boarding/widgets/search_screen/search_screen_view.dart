import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/models/supported_banks_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/search_screen/search_result.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';
import 'package:privo/components/skeletons/skeletons.dart';

import '../../../../../res.dart';
import 'search_screen_logic.dart';

class SearchScreenView extends StatelessWidget {
  final logic = Get.find<SearchScreenLogic>();

  // TODO: have scope to refactor
  SearchScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        title: GetBuilder<SearchScreenLogic>(
          builder: (logic) {
            return Text(
              logic.computeTitle(),
              style: GoogleFonts.poppins(
                color: const Color(0xff151742),
                letterSpacing: 0.13,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: GetBuilder<SearchScreenLogic>(
        builder: (logic) {
          return _searchListWidget();
        },
      ),
    );
  }

  Widget _searchTextField() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (logic.searchType == SearchType.bankDetails)
            Text(
              logic.subTitleForBank,
              style: const TextStyle(
                letterSpacing: 0.16,
                color: darkBlueColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(
            height: 16,
          ),
          _textInputField(),
        ],
      ),
    );
  }

  Widget _textInputField() {
    return TextField(
      controller: logic.searchController,
      onChanged: logic.onSearch,
      maxLength: 256,
      autofocus: logic.searchType == SearchType.employerSearch,
      inputFormatters: [
        NoLeadingSpaceFormatter(),
        NoSpecialCharacterFormatter(),
      ],
      decoration: InputDecoration(
        counterText: "",
        hintText: logic.HINT_TEXT,
        isDense: false,
        prefixIcon: const Icon(
          Icons.search,
          color: darkBlueColor,
        ),
        suffixIcon: InkWell(
          onTap: logic.onClearTextClicked,
          child: const Icon(Icons.close),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        enabledBorder: _searchTextFieldBorder(),
        focusedBorder: _searchTextFieldBorder(),
        border: _searchTextFieldBorder(),
      ),
    );
  }

  InputBorder _searchTextFieldBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: secondaryDarkColor, width: 0.8),
      borderRadius: BorderRadius.circular(32),
    );
  }

  Widget _searchListWidget() {
    switch (logic.searchType) {
      case SearchType.employerSearch:
        return _employerSearchResultWidget();
      case SearchType.bankDetails:
        return _bankListWidget();
      case SearchType.businessSector:
        return _businessSectorListWidget();
    }
  }

  Widget _bankListWidget() {
    return GetBuilder<SearchScreenLogic>(
      id: 'bank_list',
      builder: (logic) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _searchTextField(),
            logic.filteredBankList.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      controller: logic.controller,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shrinkWrap: true,
                      itemCount: logic.filteredBankList.length,
                      itemBuilder: (_, index) {
                        BanksModel bank = logic.filteredBankList[index];
                        return ListTile(
                          visualDensity: const VisualDensity(
                            horizontal: -4,
                            vertical: -2,
                          ),
                          onTap: () => logic.onTapBankTile(bank),
                          leading: Material(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                            elevation: 2,
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              child: SvgPicture.asset(
                                logic.getBankLogo(
                                    perfiosBankName: bank.perfiosBankName),
                                width: 16,
                                height: 16,
                              ),
                            ),
                          ),
                          title: Text(
                            bank.perfiosBankName,
                            style: const TextStyle(
                              color: Color(0xff404040),
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.22,
                              fontSize: 14,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No results found",
                            style: _noResultFoundTitleTextStyle()),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("We couldn't find what you are looking for",
                            style: _noResultFoundSubTitleTextStyle()),
                      ],
                    ),
                  ),
            if (logic.isEndOfList) ...[
              Divider(
                color: Colors.grey.shade300,
                height: 1,
              ),
              _bankNotFoundWidget()
            ]
          ],
        );
      },
    );
  }

  InkWell _bankNotFoundWidget() {
    return InkWell(
      onTap: logic.onBankNotFoundClicked,
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
              color: primaryLightColor,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    Res.bankIcon,
                  ),
                  const HorizontalSpacer(8),
                  const Text(
                    "Bank not found? Click here",
                    style: TextStyle(
                      color: navyBlueColor,
                      letterSpacing: 0.22,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: navyBlueColor,
              ),
            ],
          )),
    );
  }

  Widget _employerSearchResultWidget() {
    return Column(
      children: [
        _searchTextField(),
        Expanded(
          child: logic.makingAPICall
              ? _listLoadingWidget()
              : logic.validateSearchField()
                  ? ListTile(
                      onTap: () {
                        Get.back(result: logic.searchController.text.trim());
                      },
                      title: Text(logic.searchController.text.trim()),
                      trailing: const Icon(Icons.arrow_right),
                    )
                  : _resultListWidget(),
        ),
      ],
    );
  }

  Widget _businessSectorListWidget() {
    return Column(
      children: [
        _searchTextField(),
        Expanded(
          child: logic.validateSearchField()
              ? ListTile(
                  onTap: () {
                    Get.back(result: logic.searchController.text.trim());
                  },
                  title: Text(logic.searchController.text.trim()),
                  trailing: const Icon(Icons.arrow_right),
                )
              : _businessSectorResultListWidget(),
        ),
      ],
    );
  }

  ListView _resultListWidget() {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      padding: const EdgeInsets.all(10),
      itemCount: logic.searchResult.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Get.back(
                result: SearchResult(
                    companyName: logic.searchResult[index],
                    manual: index == 0 ? true : false));
          },
          title: Text(logic.searchResult[index]),
          trailing: index == 0 ? const Icon(Icons.arrow_right) : null,
        );
      },
    );
  }

  ListView _businessSectorResultListWidget() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: logic.searchResult.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Get.back(result: logic.searchResult[index]);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              logic.searchResult[index],
              style: const TextStyle(fontSize: 14, color: primaryDarkColor),
            ),
          ),
        );
      },
    );
  }

  SkeletonItem _listLoadingWidget() {
    return SkeletonItem(
      child: ListView.separated(
        itemCount: 20,
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemBuilder: (context, index) {
          return const Column(
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 8,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 7,
                ),
              ),
            ],
          );
        },
        padding: const EdgeInsets.symmetric(horizontal: 25),
      ),
    );
  }

  TextStyle _noResultFoundSubTitleTextStyle() {
    return const TextStyle(
      color: primaryDarkColor,
      letterSpacing: 0.22,
      fontSize: 12,
    );
  }

  TextStyle _noResultFoundTitleTextStyle() {
    return const TextStyle(
        color: Color(0xff1D478E),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.22,
        fontSize: 16,
        fontFamily: 'Figtree');
  }
}
