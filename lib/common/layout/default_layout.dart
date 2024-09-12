import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Color? appBarBackGroundColor;
  final Color? appBarForegroundColor;
  final Widget child;
  final Widget? titleWidget;
  final bool? centerTitle;
  final double? titleSpacing;
  final Widget? titleLeading;
  final double? titleLeadingWidth;
  final List<Widget>? titleActions;
  final Widget? titleFlexibleSpace;
  final bool automaticallyImplyLeading;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final bool drawerEnableOpenDragGesture;
  final double? appBarHeight;
  final DeviceOrientation deviceOrientation;
  final PreferredSizeWidget? bottom;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool? resizeToAvoidBottomInset;
  final Color? statusBarColor;
  final Brightness? statusBarBrightness;
  final Color? systemNavigationBarColor;
  final Brightness? systemNavigationBarIconBrightness;

  const DefaultLayout({
    required this.child,
    this.scaffoldKey,
    this.backgroundColor,
    this.appBarBackGroundColor,
    this.appBarForegroundColor,
    this.titleWidget,
    this.centerTitle,
    this.titleSpacing,
    this.titleLeading,
    this.titleLeadingWidth,
    this.titleActions,
    this.titleFlexibleSpace,
    this.automaticallyImplyLeading = true,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.drawer,
    this.appBarHeight,
    this.bottom,
    this.drawerEnableOpenDragGesture = false,
    this.deviceOrientation = DeviceOrientation.portraitUp,
    this.resizeToAvoidBottomInset,
    this.statusBarColor,
    this.statusBarBrightness,
    this.systemNavigationBarColor,
    this.systemNavigationBarIconBrightness,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([deviceOrientation]);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: statusBarBrightness,
        statusBarBrightness: statusBarBrightness,
        systemNavigationBarColor: systemNavigationBarColor,
        systemNavigationBarIconBrightness: systemNavigationBarIconBrightness,
      ),
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        backgroundColor: backgroundColor ?? ColorName.white000,
        appBar: renderAppBar(),
        drawer: drawer,
        drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
        body: child,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }

  AppBar? renderAppBar() {
    if (titleWidget == null) {
      return null;
    } else {
      return AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: appBarBackGroundColor ?? ColorName.white000,
        elevation: 0,
        centerTitle: centerTitle,
        toolbarHeight: appBarHeight,
        automaticallyImplyLeading: automaticallyImplyLeading,
        leading: titleLeading,
        leadingWidth: titleLeadingWidth,
        flexibleSpace: titleFlexibleSpace,
        actions: titleActions,
        titleSpacing: titleSpacing,
        title: titleWidget,
        foregroundColor: appBarForegroundColor ?? Colors.black,
        bottom: bottom,
      );
    }
  }
}
