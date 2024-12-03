import 'package:academic/app/utils/theme/color_theme.dart';
import 'package:flutter/material.dart';

Future<dynamic> buildShowModalBottomSheet(BuildContext context,Widget child) {
  return showModalBottomSheet<dynamic>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    backgroundColor: background,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
    builder: (context) {
      return Theme(
        data: Theme.of(context).copyWith(
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              backgroundColor:
              WidgetStateColor.resolveWith((states) => background),
              foregroundColor:
              WidgetStateColor.resolveWith((states) => background),
            ),
          ),
        ),
        child: Wrap(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: child,
            ),
          ],
        ),
      );
    },
  );
}
