// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'dart:io' show Platform;


// Future<void> navigateTo(BuildContext context, Widget screen) async {
//   if (Platform.isAndroid) {
//     // Android: Use custom MaterialPageRoute with transition
//     Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
//   } else if (Platform.isIOS) {
//     // iOS: Use default CupertinoPageRoute
//     Navigator.of(context).push(CupertinoPageRoute(builder: (_) => screen));
//   }
// }

// Future<void> navigateReplacementTo(BuildContext context, Widget screen) async {
//   if (Platform.isAndroid) {
//     // Android: Use custom MaterialPageRoute with transition
//     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => screen));
//   } else if (Platform.isIOS) {
//     // iOS: Use default CupertinoPageRoute
//     Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (_) => screen));
//   }
// }

// Future<void> navigateAndRemoveUntil(BuildContext context, Widget screen) async {
//   if (Platform.isAndroid) {
//     // Android: Use custom MaterialPageRoute with transition
//     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => screen), (route) => false);
//   } else if (Platform.isIOS) {
//     // iOS: Use default CupertinoPageRoute
//     Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (_) => screen), (route) => false);
//   }
// }

