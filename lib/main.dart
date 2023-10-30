import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:threat_detection_flutter/notification.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Geolocator.requestPermission();

    FlutterLocalNotification.init();

    Future.delayed(const Duration(seconds: 3),
        FlutterLocalNotification.requestNotificationPermission());
  }

  @override
  void dispose() {
    super.dispose();
  }

  final Set<JavascriptChannel> jsChannels = {
    JavascriptChannel(
        name: "Threat",
        onMessageReceived: (message) {
          FlutterLocalNotification.showNotification();
        }),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // body: Center(
        //     child: TextButton(
        //   onPressed: () => FlutterLocalNotification.showNotification(),
        //   child: const Text("알림"),
        // )),
        // body: const WebViewWrapper(),
        body: Stack(
      children: [
        WebviewScaffold(
          url: "https://c387-203-247-167-58.ngrok-free.app",
          withZoom: false,
          withLocalStorage: true,
          geolocationEnabled: true,
          withJavascript: true,
          ignoreSSLErrors: true,
          javascriptChannels: jsChannels,
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () => FlutterLocalNotification.showNotification(),
            elevation: 0,
            child: const Icon(Icons.notifications),
          ),
        ),
      ],
    ));
  }
}

class WebViewWrapper extends StatefulWidget {
  const WebViewWrapper({Key? key}) : super(key: key);

  @override
  State<WebViewWrapper> createState() => _WebViewWrapperState();
}

class _WebViewWrapperState extends State<WebViewWrapper> {
  late final WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false);
    controller
        .loadRequest(Uri.parse("https://c387-203-247-167-58.ngrok-free.app"));
    // controller.loadFlutterAsset("assets/html/index.html");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}
