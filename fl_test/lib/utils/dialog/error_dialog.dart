import 'package:fl_test/utils/dialog/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'An error eccured',
    content: text,
    optionBuilder: () => {'OK': null},
  );
}
