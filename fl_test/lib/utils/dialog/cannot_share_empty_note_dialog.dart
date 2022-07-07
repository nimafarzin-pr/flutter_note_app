import 'package:fl_test/utils/dialog/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
      context: context,
      title: 'Sharing',
      content: 'You can not share an empty note!',
      optionBuilder: () => {
            'OK': null,
          });
}
