import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const IthalatHubApp());
}

class IthalatHubApp extends StatelessWidget {
  const IthalatHubApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'İthalatHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4318FF),
        scaffoldBackgroundColor: const Color(0xFFF4F7FE),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainWebViewScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4318FF), Color(0xFF1B2559)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.blur_on, size: 100, color: Colors.white),
            const SizedBox(height: 24),
            const Text(
              'İTHALATHUB',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Küresel Ticaret & Lojistik Portalı',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class MainWebViewScreen extends StatefulWidget {
  const MainWebViewScreen({Key? key}) : super(key: key);

  @override
  _MainWebViewScreenState createState() => _MainWebViewScreenState();
}

class _MainWebViewScreenState extends State<MainWebViewScreen> {
  InAppWebViewController? webViewController;
  bool _hasInternet = true;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (webViewController != null && await webViewController!.canGoBack()) {
          webViewController!.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              if (_hasInternet)
                InAppWebView(
                  initialUrlRequest: URLRequest(url: Uri.parse("https://ithalathub.com")),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      useShouldOverrideUrlLoading: true,
                      mediaPlaybackRequiresUserGesture: false,
                      javaScriptEnabled: true,
                      supportZoom: false,
                    ),
                    android: AndroidInAppWebViewOptions(
                      useHybridComposition: true,
                    ),
                    ios: IOSInAppWebViewOptions(
                      allowsLinkPreview: false,
                    ),
                  ),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStop: (controller, url) {
                    setState(() {
                      _isLoading = false;
                      _hasInternet = true;
                    });
                  },
                  onLoadError: (controller, url, code, message) {
                    setState(() {
                      _isLoading = false;
                      _hasInternet = false;
                    });
                  },
                )
              else
                Container(
                  color: const Color(0xFFF4F7FE),
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off_rounded, size: 80, color: Color(0xFF4318FF)),
                      const SizedBox(height: 20),
                      const Text(
                        'Bağlantı Hatası',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B2559)),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'İthalatHub paneline erişebilmek için lütfen internet bağlantınızı kontrol edin.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4318FF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        ),
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _hasInternet = true;
                          });
                          if (webViewController != null) {
                            webViewController!.loadUrl(urlRequest: URLRequest(url: Uri.parse("https://ithalathub.com")));
                          }
                        },
                        child: const Text('Tekrar Dene', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      )
                    ],
                  ),
                ),
              if (_isLoading && _hasInternet)
                const Center(
                  child: CircularProgressIndicator(color: Color(0xFF4318FF)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}