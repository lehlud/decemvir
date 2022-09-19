import 'package:flutter/widgets.dart';

Future<void> showInstantDialog({
  required BuildContext context,
  required Widget Function(BuildContext context) builder,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'close modal',
    transitionDuration: const Duration(),
    pageBuilder: (context, animation, secondaryAnimation) {
      return builder(context);
    },
  );
}
