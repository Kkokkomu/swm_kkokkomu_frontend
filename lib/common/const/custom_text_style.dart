import 'dart:ui';

import 'package:swm_kkokkomu_frontend/common/const/custom_font_weight.dart';
import 'package:swm_kkokkomu_frontend/common/gen/fonts.gen.dart';

class CustomTextStyle {
  static const String fontFamily = FontFamily.pretendard;
  static const Color textColor = Color(0xFF000000);

  static final TextStyle head1 = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.extraBold,
    fontSize: 24,
    height: 1.5,
  );

  static final TextStyle head2 = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.bold,
    fontSize: 22,
    height: 1.5,
  );

  static final TextStyle head3 = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.semiBold,
    fontSize: 20,
    height: 1.5,
  );

  static final TextStyle head4 = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.medium,
    fontSize: 18,
    height: 1.5,
  );

  static final TextStyle body1Bold = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.bold,
    fontSize: 16,
    height: 1.4,
  );

  static final TextStyle body1Medi = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.medium,
    fontSize: 16,
    height: 1.4,
  );

  static final TextStyle body1Reg = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.regular,
    fontSize: 16,
    height: 1.4,
  );

  static final TextStyle body2Bold = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.bold,
    fontSize: 15,
    height: 1.4,
  );

  static final TextStyle body2Medi = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.medium,
    fontSize: 15,
    height: 1.4,
  );

  static final TextStyle body2Reg = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.regular,
    fontSize: 15,
    height: 1.4,
  );

  static final TextStyle body3Bold = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.bold,
    fontSize: 14,
    height: 1.4,
  );

  static final TextStyle body3Medi = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.medium,
    fontSize: 14,
    height: 1.4,
  );

  static final TextStyle detail1Bold = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.bold,
    fontSize: 13,
    height: 1.4,
  );

  static final TextStyle detail1Medi = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.medium,
    fontSize: 13,
    height: 1.4,
  );

  static final TextStyle detail1Reg = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.regular,
    fontSize: 13,
    height: 1.4,
  );

  static final TextStyle detail2Bold = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.bold,
    fontSize: 12,
    height: 1.4,
  );

  static final TextStyle detail2Reg = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.regular,
    fontSize: 12,
    height: 1.4,
  );

  static final TextStyle detail3Semi = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.semiBold,
    fontSize: 11,
    height: 1.4,
  );

  static final TextStyle detail3Reg = TextStyle(
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: CustomFontWeight.regular,
    fontSize: 11,
    height: 1.4,
  );
}
