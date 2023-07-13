import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_360_test/video_360_page.dart';
import 'package:uni_links/uni_links.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final init = await _handleInitialLink();
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Video360Page(initialLink: init),
      },
      debugShowCheckedModeBanner: false,
    ),
  );
}

Future<String?> _handleInitialLink() async {
  try {
    final url = await getInitialLink();
    if (!(url == null)) {
      return url;
    }
  } on Exception catch (_, err) {
    if (kDebugMode) {
      print(err.toString());
    }
  }
  return null;
}
