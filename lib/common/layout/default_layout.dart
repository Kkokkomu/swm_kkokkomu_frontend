import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swm_kkokkomu_frontend/common/const/app_colors.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Color? appBarBackGroundColor;
  final Widget child;
  final Widget? titleWidget;
  final double? titleSpacing;
  final double? leadingWidth;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final bool drawerEnableOpenDragGesture;
  final double? appBarHeight;
  final DeviceOrientation deviceOrientation;
  final PreferredSizeWidget? bottom;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool? resizeToAvoidBottomInset;

  const DefaultLayout({
    required this.child,
    this.scaffoldKey,
    this.backgroundColor,
    this.appBarBackGroundColor,
    this.titleWidget,
    this.titleSpacing,
    this.leadingWidth,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.drawer,
    this.appBarHeight,
    this.bottom,
    this.drawerEnableOpenDragGesture = false,
    this.deviceOrientation = DeviceOrientation.portraitUp,
    this.resizeToAvoidBottomInset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([deviceOrientation]);

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor ?? AppColors.white000,
      appBar: renderAppBar(),
      drawer: drawer,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }

  AppBar? renderAppBar() {
    if (titleWidget == null) {
      return null;
    } else {
      return AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: appBarBackGroundColor ?? AppColors.white000,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: appBarHeight,
        leadingWidth: leadingWidth,
        titleSpacing: titleSpacing,
        title: titleWidget,
        foregroundColor: Colors.black,
        bottom: bottom,
      );
    }
  }
}
