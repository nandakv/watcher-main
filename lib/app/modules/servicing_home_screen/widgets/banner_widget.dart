
import 'package:privo/app/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
class BannerWidget extends StatelessWidget {

  const BannerWidget({Key? key, this.bannerColor,this.bannerTextColor,this.bannerText}) : super(key: key);
  final Color? bannerColor;
  final Color? bannerTextColor;
  final String? bannerText;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(80,
          (20).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
      painter: CustomBannerPainter(bannerColor),
      child: Padding(
        padding:const EdgeInsets.symmetric(vertical: 2,horizontal: 15),
        child: Text(
          bannerText ?? "",
          style: overPassStyle(
              color: bannerTextColor,
              fontsize: 10),
        ),
      ),
    );
  }
}

class CustomBannerPainter extends CustomPainter {
  CustomBannerPainter(this.bannerColor);
  final Color? bannerColor;
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.lineTo(size.width, 0);
    path_0.lineTo(size.width, size.height);
    path_0.lineTo(0, size.height);
    path_0.lineTo(size.width * 0.1007836, size.height * 0.5261250);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = bannerColor!;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
