import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ahioma_food_template/core/constants/app_constants.dart';

extension NumberExtension on num {
  TextStyle get w100 {
    return TextStyle(
      fontSize: spMin,
      fontWeight: FontWeight.w100,
      fontFamily: AppConstants.fontFamilyName,
    );
  }

  TextStyle get w200 {
    return TextStyle(
      fontSize: spMin,
      fontWeight: FontWeight.w200,
      fontFamily: AppConstants.fontFamilyName,
    );
  }

  TextStyle get w300 {
    return TextStyle(
      fontSize: spMin,
      fontWeight: FontWeight.w300,
      fontFamily: AppConstants.fontFamilyName,
    );
  }

  TextStyle get w400 {
    return TextStyle(
      fontSize: spMin,
      fontWeight: FontWeight.w400,
      fontFamily: AppConstants.fontFamilyName,
    );
  }

  TextStyle get regular {
    return TextStyle(
      fontSize: spMin,
      fontWeight: FontWeight.w500,
      fontFamily: AppConstants.fontFamilyName,
    );
  }

  TextStyle get w500 {
    return TextStyle(
      fontSize: spMin,
      fontWeight: FontWeight.w500,
      fontFamily: AppConstants.fontFamilyName,
    );
  }

  TextStyle get w600 {
    return TextStyle(
      fontSize: spMin,
      fontWeight: FontWeight.w600,
      fontFamily: AppConstants.fontFamilyName,
    );
  }

  TextStyle get w700 {
    return TextStyle(
      fontSize: spMin,
      fontWeight: FontWeight.w700,
      fontFamily: AppConstants.fontFamilyName,
    );
  }

  TextStyle get w800 {
    return TextStyle(
      fontSize: spMin,
      fontWeight: FontWeight.w800,
      fontFamily: AppConstants.fontFamilyName,
    );
  }

  TextStyle get w900 {
    return TextStyle(
      fontSize: spMin,
      fontWeight: FontWeight.w900,
      fontFamily: AppConstants.fontFamilyName,
    );
  }

  TextStyle get bold {
    return TextStyle(
      fontSize: spMin,
      fontWeight: FontWeight.bold,
      fontFamily: AppConstants.fontFamilyName,
    );
  }
}

extension MoneyFormat on num {
  double get toRadians => this * (pi / 180.0);

  String get getValue {
    final formatter = NumberFormat('#,##0.###');
    final parts = '$this'.split('.');
    String text;
    if (parts.length > 1) {
      // If there's a decimal part, format accordingly
      final integerPart = int.tryParse(parts[0]) ?? 0;
      final decimalPart = parts[1];
      // Handle edge case where decimal
      // part is present but empty (user just typed the dot)
      text = '${formatter.format(integerPart)}.$decimalPart';
    } else {
      // No decimal part, format the whole number
      text = formatter.format(this);
    }
    return 'NGN $text';
  }

  SliverToBoxAdapter get sbH {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: toDouble(),
      ),
    );
  }

  SliverToBoxAdapter get sbW {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: toDouble(),
      ),
    );
  }

  SizedBox get vertSpacing {
    return SizedBox(
      height: toDouble(),
    );
  }

  SizedBox get horizSpacing {
    return SizedBox(
      width: toDouble(),
    );
  }
}
