import 'package:fl_test/utils/dialog/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showPasswordResetSendEmailDialog({required BuildContext context}) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password reset',
    content:
        'We have now send you a password reset link. Please check your email for moere information',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
