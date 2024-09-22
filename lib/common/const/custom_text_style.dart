import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_font_weight.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/fonts.gen.dart';

class CustomTextStyle {
  static const String fontFamily = FontFamily.pretendard;
  static const Color textColor = ColorName.gray700;

  static TextStyle head1({Color color = textColor}) => TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.extraBold,
        fontSize: 24,
        height: 1.5,
      );

  static TextStyle head2({Color color = textColor}) => TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.bold,
        fontSize: 22,
        height: 1.5,
      );

  static TextStyle head3({Color color = textColor}) => TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.semiBold,
        fontSize: 20,
        height: 1.5,
      );

  static TextStyle head4({Color color = textColor}) => TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.medium,
        fontSize: 18,
        height: 1.5,
      );

  static TextStyle body1Bold({Color color = textColor}) => TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.bold,
        fontSize: 16,
        height: 1.4,
      );

  static TextStyle body1Medi({Color color = textColor}) => TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.medium,
        fontSize: 16,
        height: 1.4,
      );

  static TextStyle body1Reg({Color color = textColor}) => TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.regular,
        fontSize: 16,
        height: 1.4,
      );

  static TextStyle body2Bold({Color color = textColor}) => TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.bold,
        fontSize: 15,
        height: 1.4,
      );

  static TextStyle body2Medi({Color color = textColor}) => TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.medium,
        fontSize: 15,
        height: 1.4,
      );

  static TextStyle body2Reg({Color color = textColor}) => TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.regular,
        fontSize: 15,
        height: 1.4,
      );

  static TextStyle body3Bold({Color color = textColor}) => TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.bold,
        fontSize: 14,
        height: 1.4,
      );

  static TextStyle body3Medi({Color color = textColor}) => TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.medium,
        fontSize: 14,
        height: 1.4,
      );

  static TextStyle detail1Bold({Color color = textColor}) => TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.bold,
        fontSize: 13,
        height: 1.4,
      );

  static TextStyle detail1Medi({Color color = textColor}) => TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.medium,
        fontSize: 13,
        height: 1.4,
      );

  static TextStyle detail1Reg({
    Color color = textColor,
    TextDecoration? decoration,
    Color? decorationColor,
    double? decorationThickness,
  }) =>
      TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.regular,
        fontSize: 13,
        height: 1.4,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
      );

  static TextStyle detail2Bold({Color color = textColor}) => TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.bold,
        fontSize: 12,
        height: 1.4,
      );

  static TextStyle detail2Reg({Color color = textColor}) => TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.regular,
        fontSize: 12,
        height: 1.4,
      );

  static TextStyle detail3Semi({Color color = textColor}) => TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.semiBold,
        fontSize: 11,
        height: 1.4,
      );

  static TextStyle detail3Reg({Color color = textColor}) => TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontWeight: CustomFontWeight.regular,
        fontSize: 11,
        height: 1.4,
      );
}
