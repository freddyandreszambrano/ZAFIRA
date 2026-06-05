import 'package:flutter/material.dart';

/// * This [sizes] are the standard
/// 0 [None]
/// 5 [XSm]
/// 10 [Sm]
/// 15 [Md]
/// 20 [Lg]
/// 25 [XLg]
/// [kRadiusCircular] is a special case for curves totally circular
///
/// * This [types] are the standard
/// [kRadius] [preferred] [separator] [kSpaceDevice]
///
/// ** [preferredSize] affect all the headers the standard sizes are
/// [preferredSize] header without tabs
/// [preferredSizeTabs] header with tabs
///
/// ** [deviceSize]
/// general size for tablet devices [tabletSize]
/// devices medium but tight [tightSize]
/// really small devices under 5" [smDevice]
///
/// ** [kSpaceDevice] can be combined with this Suffixes
/// Top [T]
/// Right [R]
/// Bottom [B]
/// Left [L]
/// Horizontal [H]
/// Vertical [V]
///
/// *** Special combinations
/// [HV] horizontal and vertical with different proportions
/// this has two variations [normal] and [special]
/// try to use always the first one
///
/// [HT] [HB] horizontally but only included Top or Bottom with same sized
/// only for Medium size [15]
///
/// *** Skeleton colors
///
/// *** Identifier's type;
/// [01100001] id or [allAsIdentifier] for sections that need a section wrapping all data;
/// [01000110] id or [featuredIdentifier] for sections that need a featured block wrapped as one;
///
/// *** Action's Space type;
/// [twoActionsSpace]  handle three action space with search input;
/// [threeActionsSpace]  handle two action space with search input;
/// [actionsSpace] handle one action space with search input;
/// [actionsSpaceFull] handle one action space,no hamburger with search input;
///
///  *** BottomSheet shape - Rounded rectangle border
///  A medium border rounded  [roundedRectangleTMd]

const int allAsIdentifier = 01100001;
const int featuredIdentifier = 01000110;
const int twoActionsSpace = 140;
const int threeActionsSpace = 160;
const int actionsSpace = 120;
const int actionsSpaceFull = 80;
const double tabletSize = 600;
const double tabletSizeLandscape = 900;
const double tightSize = 380;
const double smDevice = 340;
const double kRadiusNone = 0;
const double kRadiusXSm = 5;
const double kRadiusSm = 10;
const double kRadiusMd = 15;
const double kRadiusLg = 20;
const double kRadiusXLg = 25;
const double kRadiusCircular = 30;
const double textShortLength = 12;
const double textLongLength = 17;
const Size preferredSize = Size.fromHeight(55);
const Size preferredSizeTabsAndTimer = Size.fromHeight(170);
const Size preferredSizeTabs = Size.fromHeight(110);
const Size preferredSizeMobileSm = Size.fromWidth(380);
const Size preferredSizeHome = Size.fromHeight(90);
const Size preferredSizeSubHeaderTabs = Size.fromHeight(40);
const double separatorNone = 0;
const double separatorXSm = 5;
const double separatorSm = 10;
const double separatorMd = 15;
const double separatorLg = 20;
const double separatorXLg = 40;
const double separatorXXLg = 60;
const EdgeInsets kSpaceDeviceNone = EdgeInsets.all(0);
const EdgeInsets kSpaceDeviceXSm = EdgeInsets.all(5);
const EdgeInsets kSpaceDeviceSm = EdgeInsets.all(10);
const EdgeInsets kSpaceDeviceMd = EdgeInsets.all(15);
const EdgeInsets kSpaceDeviceLg = EdgeInsets.all(20);
const EdgeInsets kSpaceDeviceXLg = EdgeInsets.all(40);
const EdgeInsets kSpaceDeviceTXSm = EdgeInsets.only(top: 5);
const EdgeInsets kSpaceDeviceTSm = EdgeInsets.only(top: 10);
const EdgeInsets kSpaceDeviceTMd = EdgeInsets.only(top: 15);
const EdgeInsets kSpaceDeviceRXSm = EdgeInsets.only(right: 5);
const EdgeInsets kSpaceDeviceRSm = EdgeInsets.only(right: 10);
const EdgeInsets kSpaceDeviceRMd = EdgeInsets.only(right: 15);
const EdgeInsets kSpaceDeviceRLg = EdgeInsets.only(right: 20);
const EdgeInsets kSpaceDeviceRYLg = EdgeInsets.only(right: 30);
const EdgeInsets kSpaceDeviceBXSm = EdgeInsets.only(bottom: 5);
const EdgeInsets kSpaceDeviceBSm = EdgeInsets.only(bottom: 10);
const EdgeInsets kSpaceDeviceBMd = EdgeInsets.only(bottom: 15);
const EdgeInsets kSpaceDeviceBLg = EdgeInsets.only(bottom: 20);
const EdgeInsets kSpaceDeviceLXSm = EdgeInsets.only(left: 5);
const EdgeInsets kSpaceDeviceLSm = EdgeInsets.only(left: 10);
const EdgeInsets kSpaceDeviceLMd = EdgeInsets.only(left: 15);
const EdgeInsets kSpaceDeviceLLg = EdgeInsets.only(left: 20);
const EdgeInsets kSpaceDeviceLVLg = EdgeInsets.only(left: 30);
const EdgeInsets kSpaceDeviceVXSm = EdgeInsets.symmetric(vertical: 5);
const EdgeInsets kSpaceDeviceVSm = EdgeInsets.symmetric(vertical: 10);
const EdgeInsets kSpaceDeviceVMd = EdgeInsets.symmetric(vertical: 15);
const EdgeInsets kSpaceDeviceVLg = EdgeInsets.symmetric(vertical: 20);
const EdgeInsets kSpaceDeviceHXSm = EdgeInsets.symmetric(horizontal: 5);
const EdgeInsets kSpaceDeviceHSm = EdgeInsets.symmetric(horizontal: 10);
const EdgeInsets kSpaceDeviceHMd = EdgeInsets.symmetric(horizontal: 15);
const EdgeInsets kSpaceDeviceHLg = EdgeInsets.symmetric(horizontal: 20);
const EdgeInsets kSpaceDeviceHXLg = EdgeInsets.symmetric(horizontal: 30);
const EdgeInsets kSpaceDeviceHVMd =
    EdgeInsets.symmetric(horizontal: 15, vertical: 15);
const EdgeInsets kSpaceDeviceHVNormal =
    EdgeInsets.symmetric(horizontal: 15, vertical: 5);
const EdgeInsets kSpaceDeviceHVNSmall =
    EdgeInsets.symmetric(horizontal: 15, vertical: 2.5);
const EdgeInsets kSpaceDeviceHVSpecial =
    EdgeInsets.symmetric(horizontal: 15, vertical: 10);
const EdgeInsets kReceiptStatePadding =
    EdgeInsets.symmetric(horizontal: 8, vertical: 2);
const EdgeInsets kSpaceDeviceHTAsymmetric =
    EdgeInsets.only(top: 8, right: 15, left: 15);
const EdgeInsets kSpaceDeviceHT = EdgeInsets.only(top: 15, right: 15, left: 15);
const EdgeInsets kSpaceDeviceHBSm =
    EdgeInsets.only(bottom: 10, right: 10, left: 10);
const EdgeInsets kSpaceDeviceHB =
    EdgeInsets.only(bottom: 15, right: 15, left: 15);
const EdgeInsets kSectionPadding =
    EdgeInsets.symmetric(horizontal: 16, vertical: 8);
const Radius bubbleBorder = Radius.circular(kRadiusSm);
const Duration retailDurationTimer = Duration(minutes: 15);
const double imageSize = 25;
const Color negativeBaseColor = Color(0xffF1F1F1);
const Color negativeHighlightColor = Color(0x1FFFFFFF);
const Color positiveBaseColor = Color(0x1FFFFFFF);
const Color positiveHighlightColor = Color(0x99FFFFFF);
const RoundedRectangleBorder roundedRectangleTMd = RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusMd)),
);
const RoundedRectangleBorder roundedRectangleAllMd = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(kRadiusMd)),
);
const BorderRadius kBorderRadiusAllMedium =
    BorderRadius.all(Radius.circular(kRadiusMd));
const BorderRadius kBorderRadiusAllSmall =
    BorderRadius.all(Radius.circular(kRadiusSm));
const BorderRadius kBorderRadiusAllLarge =
    BorderRadius.all(Radius.circular(kRadiusLg));
const BorderRadius kBorderRadiusAllXLarge =
    BorderRadius.all(Radius.circular(kRadiusXLg));

const String defaultLanguage = "ES";

const double smallDevices = 360;
const double kBottomSheetHeightFactor = 0.7;
const double kBottomSheetNoDataHeightFactor = 0.4;
const double kSubmoduleCardMainAxisExtent = 200;
const double kSubmoduleCardCrossAxisExtent = 200;
const double kModuleCardMainAxisExtent = 280;
const double kModuleCardCrossAxisExtent = 320;
const double kSubmoduleImageHeight = 100;
const double kModuleImageHeight = 100;

const double kWorkOrderCardWidth = 260;
const double kWorkOrderCardHeight = 155;
const EdgeInsets kWorkOrderCardPadding = EdgeInsets.fromLTRB(15, 15, 15, 10);
const EdgeInsets kWorkOrderStatusPadding = EdgeInsets.symmetric(
  horizontal: 8,
  vertical: 3,
);
const double kWorkOrderStatusDotSize = 5;

const double toolActionButtonSize = 36;
const double toolActionIconSize = 17;
const double toolActionLoaderSize = 14;

const double toolStepDotSize = 32;
const double toolStepLabelWidth = 72;
