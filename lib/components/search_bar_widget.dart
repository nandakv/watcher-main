import 'package:flutter/material.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/no_leading_space_formatter.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String) onChange;
  final Function() onClearClicked;
  final TextEditingController searchController;
  final String hintText;
  final String helpText;
  const SearchBarWidget({
    super.key,
    required this.onChange,
    required this.onClearClicked,
    required this.searchController,
    this.hintText = "Search",
    this.helpText = "",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _searchTextField(),
        if (helpText.isNotEmpty) _helpTextWidget(),
      ],
    );
  }

  Widget _searchTextField() {
    return TextField(
      controller: searchController,
      onChanged: onChange,
      maxLength: 256,
      inputFormatters: [
        NoLeadingSpaceFormatter(),
        NoSpecialCharacterFormatter(),
      ],
      decoration: InputDecoration(
        counterText: "",
        hintText: hintText,
        hintStyle: const TextStyle(
          color: secondaryDarkColor,
          fontWeight: FontWeight.w300,
          fontSize: 14,
          height: 20 / 14,
        ),
        isDense: false,
        prefixIcon: const Icon(Icons.search, color: darkBlueColor),
        suffixIcon: InkWell(
          onTap: onClearClicked,
          child: const Icon(Icons.close),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  Widget _helpTextWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 46),
      child: Text(
        helpText,
        style: const TextStyle(
          color: secondaryDarkColor,
          fontSize: 10,
          height: 1.4,
        ),
      ),
    );
  }
}
