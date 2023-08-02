import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

const backClr = Colors.amber;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://www.ichbinmerih.com'));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: const Text('My Website'),
          centerTitle: true,
        ),
        bottomNavigationBar: Container(
          color: backClr,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0, right: 20.0),
            child: ButtonBar(
              children: [
                navigationButton(
                  Icons.chevron_left,
                  () => _goBack(),
                ),
                navigationButton(
                  Icons.chevron_right,
                  () => _goForward(),
                ),
              ],
            ),
          ),
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }

  Widget navigationButton(IconData icon, Function() onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
    );
  }

  void _goBack() async {
    final canGoBack = await controller.canGoBack();
    if (canGoBack) {
      controller.goBack();
    }
  }

  void _goForward() async {
    final canGoForward = await controller.canGoForward();
    if (canGoForward) {
      controller.goForward();
    }
  }
}
