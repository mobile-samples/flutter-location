import 'package:flutter/material.dart';

Future<bool> confirm(
  BuildContext context, {
  Widget? title,
  Widget? content,
  Widget? textOK,
  Widget? textCancel,
}) async {
  final bool? isConfirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[50],
          actionsAlignment: MainAxisAlignment.center,
          title: Column(
            children: [
              const Icon(
                Icons.notifications,
                size: 30,
                color: Colors.red,
              ),
              title ?? const Text("Confirm"),
            ],
          ),
          content: SizedBox(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Divider(),
                  content ?? const Text('Are you sure continue?'),
                  const Divider(),
                ],
              )),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.cancel_outlined,
                    size: 12,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: textCancel ?? const Text('Cancel')),
                ],
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check,
                    size: 12,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: textOK ?? const Text('OK')),
                ],
              ),
              onPressed: () => Navigator.of(context).pop(true),
            )
          ],
        );
      });
  return isConfirm ?? false;
}

Future<void> alert(BuildContext context,
    {Widget? title, Widget? content, Widget? textOK, bool? isError}) async {
  if (isError == true) {
    title = title ?? const Text("Error");
    content = content ?? const Text("System error!");
  }
  await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[50],
          actionsAlignment: MainAxisAlignment.center,
          title: Column(
            children: [
              const Icon(
                Icons.add_alert,
                size: 30,
                color: Colors.red,
              ),
              if (title != null) title,
            ],
          ),
          content: SizedBox(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Divider(),
                  if (content != null) content,
                  const Divider(),
                ],
              )),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check,
                    size: 12,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: textOK ?? const Text('OK')),
                ],
              ),
              onPressed: () => Navigator.of(context).pop(true),
            )
          ],
        );
      });
}
