//
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class LinkedInAuthWebView extends StatefulWidget {
//   final Function(String) onAuthCodeReceived;
//
//   LinkedInAuthWebView({required this.onAuthCodeReceived});
//
//   @override
//   _LinkedInAuthWebViewState createState() => _LinkedInAuthWebViewState();
// }
//
// class _LinkedInAuthWebViewState extends State<LinkedInAuthWebView> {
//   late WebViewController _webViewController;
//   bool _isLoading = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('LinkedIn Authentication'),
//       ),
//       body: Stack(
//         children: [
//           WebView(
//             initialUrl:
//             'https://www.linkedin.com/oauth/v2/authorization?client_id=YOUR_CLIENT_ID&redirect_uri=YOUR_REDIRECT_URI&response_type=code&scope=r_liteprofile%20r_emailaddress',
//             javascriptMode: JavascriptMode.unrestricted,
//             onPageStarted: (url) {
//               setState(() {
//                 _isLoading = true;
//               });
//             },
//             onPageFinished: (url) {
//               setState(() {
//                 _isLoading = false;
//               });
//             },
//             onWebViewCreated: (WebViewController webViewController) {
//               _webViewController = webViewController;
//             },
//             navigationDelegate: (NavigationRequest request) async {
//               if (request.url.startsWith('YOUR_REDIRECT_URI')) {
//                 // Extract code from redirect URL
//                 final Uri uri = Uri.parse(request.url);
//                 final String authCode = uri.queryParameters['code'] ?? '';
//
//                 // Save authCode to SharedPreferences
//                 final prefs = await SharedPreferences.getInstance();
//                 await prefs.setString('linkedin_auth_code', authCode);
//
//                 // Notify parent widget about auth code
//                 widget.onAuthCodeReceived(authCode);
//
//                 Navigator.pop(context); // Close the WebView
//
//                 return NavigationDecision.prevent;
//               }
//               return NavigationDecision.navigate;
//             },
//           ),
//           if (_isLoading)
//             Center(
//               child: CircularProgressIndicator(),
//             ),
//         ],
//       ),
//     );
//   }
// }
