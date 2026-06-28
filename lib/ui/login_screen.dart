import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dashboard_screen.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            setState(() {
              _isLoading = false;
            });
            // Check if login is successful by checking cookies or redirect
            if (url.contains('Student/StudentDashBoard') || url.contains('Home')) {
              _extractCookiesAndNavigate();
            }
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flexstudent.nu.edu.pk/Login'));
  }

  Future<void> _extractCookiesAndNavigate() async {
    final String cookies = await _controller.runJavaScriptReturningResult('document.cookie') as String;
    // Basic extraction of ASP.NET_SessionId
    final match = RegExp(r'ASP\.NET_SessionId=([^;]+)').firstMatch(cookies);
    if (match != null) {
      final sessionId = match.group(1)!;
      context.read<ApiService>().setSessionId(sessionId);
      
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF121212), Color(0xFF1E1E2C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(Icons.school_rounded, size: 64, color: Color(0xFF00FFC2)),
                      SizedBox(height: 16),
                      Text(
                        'Ragraa Next',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Please login using the portal below. Complete the captcha to proceed.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: Stack(
                      children: [
                        WebViewWidget(controller: _controller),
                        if (_isLoading)
                          const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF00FFC2),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
