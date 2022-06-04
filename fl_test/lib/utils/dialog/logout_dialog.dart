import 'package:fl_test/utils/dialog/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showLogoutDialog(
  BuildContext context,
) {
  return showGenericDialog(
    context: context,
    title: 'LogOut',
    content: 'Are you sure to logout?',
    optionBuilder: () => {'Cancel': false, 'LogOut': true},
  ).then((value) => value ?? false);
}
