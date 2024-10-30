import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class DefaultLayoutWithDefaultAppBar extends StatelessWidget {
  final Color? backgroundColor;
  final Color? appBarBackGroundColor;
  final Color? appBarForegroundColor;
  final Widget child;
  final Widget? titleWidget;
  final String title;
  final bool isBackButtonVisible;
  final void Function()? onBackButtonPressed;
  final double? titleSpacing;
  final List<Widget>? titleActions;
  final Widget? titleFlexibleSpace;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final bool drawerEnableOpenDragGesture;
  final DeviceOrientation deviceOrientation;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool? resizeToAvoidBottomInset;
  final Color? statusBarColor;
  final Brightness? statusBarBrightness;
  final Color? systemNavigationBarColor;
  final Brightness? systemNavigationBarIconBrightness;
  final bool isBottomBorderVisible;
  final double? toolbarHeight;

  const DefaultLayoutWithDefaultAppBar({
    required this.child,
    required this.title,
    this.titleWidget,
    this.scaffoldKey,
    this.backgroundColor,
    this.appBarBackGroundColor,
    this.appBarForegroundColor,
    this.isBackButtonVisible = true,
    this.onBackButtonPressed,
    this.titleSpacing,
    this.titleActions,
    this.titleFlexibleSpace,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.drawer,
    this.drawerEnableOpenDragGesture = false,
    this.deviceOrientation = DeviceOrientation.portraitUp,
    this.resizeToAvoidBottomInset,
    this.statusBarColor,
    this.statusBarBrightness,
    this.systemNavigationBarColor,
    this.systemNavigationBarIconBrightness,
    this.isBottomBorderVisible = true,
    this.toolbarHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([deviceOrientation]);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: statusBarBrightness ?? Brightness.dark,
        statusBarBrightness: statusBarBrightness == Brightness.dark
            ? Brightness.light
            : statusBarBrightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
        systemNavigationBarColor: systemNavigationBarColor,
        systemNavigationBarIconBrightness: systemNavigationBarIconBrightness,
      ),
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        backgroundColor: backgroundColor ?? ColorName.white000,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: statusBarColor,
            statusBarIconBrightness: statusBarBrightness ?? Brightness.dark,
            statusBarBrightness: statusBarBrightness == Brightness.dark
                ? Brightness.light
                : statusBarBrightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light,
            systemNavigationBarColor: systemNavigationBarColor,
            systemNavigationBarIconBrightness:
                systemNavigationBarIconBrightness,
          ),
          scrolledUnderElevation: 0.0,
          backgroundColor: appBarBackGroundColor ?? ColorName.white000,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: toolbarHeight ?? 52.0,
          leading: isBackButtonVisible
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onBackButtonPressed,
                    child: Assets.icons.svg.btnBack.svg(),
                  ),
                )
              : null,
          leadingWidth: isBackButtonVisible ? 48.0 : null,
          flexibleSpace: titleFlexibleSpace,
          actions: titleActions,
          titleSpacing: titleSpacing,
          title: titleWidget ??
              Text(
                title,
                style: CustomTextStyle.head4(),
              ),
          foregroundColor: appBarForegroundColor ?? ColorName.gray700,
          bottom: isBottomBorderVisible
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: Container(
                    color: ColorName.gray100,
                    height: 0.5,
                  ),
                )
              : null,
        ),
        drawer: drawer,
        drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
        body: child,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
