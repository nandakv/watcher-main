import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/models/co_applicant_list_model.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class AboutCoApplicantDetails extends StatelessWidget {
  List<CoApplicantDetail> coApplicantDetailsList;
  Function(CoApplicantDetail detail, int index)? onTapCoApplicantEdit;
  Function()? onTapAddCoApplicant;
  String title;

  AboutCoApplicantDetails(
      {super.key,
      this.onTapCoApplicantEdit,
      this.onTapAddCoApplicant,
      this.title = "",
      required this.coApplicantDetailsList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: primaryDarkColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        _coApplicationDetails()
      ],
    );
  }

  Widget _coApplicantListView() {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 10),
      itemBuilder: (context, index) {
        CoApplicantDetail detail = coApplicantDetailsList[index];
        return _coApplicantDetailItem(detail, index);
      },
      separatorBuilder: (context, index) {
        return verticalSpacer(15);
      },
      physics: const NeverScrollableScrollPhysics(),
      itemCount: coApplicantDetailsList.length,
      shrinkWrap: true,
    );
  }

  Widget _coApplicantDetailItem(CoApplicantDetail detail, int index) {
     return Container(
      decoration: BoxDecoration(
        color: lightBlueColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xff229ACE),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Basic Details",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: primaryDarkColor,
                  ),
                ),
                ..._coApplicantDetailsItem(detail),
                const VerticalSpacer(20),
                const Text(
                  "Ownership Details",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: primaryDarkColor,
                  ),
                ),
                ..._ownerShipDetailsItem(detail),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  if (onTapCoApplicantEdit != null) {
                    onTapCoApplicantEdit?.call(detail, index);
                  }
                },
                child: SvgPicture.asset(Res.sbdEditIconSVG),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _coApplicantDetailsItem(CoApplicantDetail detail) {
    return [
      _valuesText("Name", "${detail.firstName} ${detail.lastName}"),
      _valuesText("Date of Birth", detail.dob),
      _valuesText("PAN", detail.pan),
      _valuesText("Phone No.", detail.phone),
      _valuesText("Email", detail.email),
      _valuesText("Correspondence Address Pincode", detail.pincode)
    ];
  }

  List<Widget> _ownerShipDetailsItem(CoApplicantDetail detail) {
    return [
      _valuesText("Designation", detail.designation),
      _valuesText("Shareholding", "${detail.shareholding}%"),
    ];
  }

  Widget _valuesText(String title, String value) {
    return Text(
      "$title: $value",
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: secondaryDarkColor,
      ),
    );
  }

  Widget _coApplicationDetails() {
    if (coApplicantDetailsList.isNotEmpty) {
      return _coApplicantListView();
    }
    return _addCoApplicantButton();
  }

  InkWell _addCoApplicantButton() {
    return InkWell(
    onTap: onTapAddCoApplicant,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: darkBlueColor),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 11,
            ),
            child: Row(
              children: [
                const Text(
                  "Co-applicant Details",
                  style: TextStyle(
                    color: primaryDarkColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                SvgPicture.asset(Res.rightCircleArrowIconSVG),
              ],
            ),
          ),
        ),
      ],
    ),
  );
  }
}
