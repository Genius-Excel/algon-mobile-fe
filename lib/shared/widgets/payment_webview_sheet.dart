import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewSheet extends StatefulWidget {
  final String paymentUrl;
  final VoidCallback onPaymentComplete;

  const PaymentWebViewSheet({
    super.key,
    required this.paymentUrl,
    required this.onPaymentComplete,
  });

  @override
  State<PaymentWebViewSheet> createState() => _PaymentWebViewSheetState();
}

class _PaymentWebViewSheetState extends State<PaymentWebViewSheet> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _paymentCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
            // Check URL on navigation start
            _checkPaymentStatus(url);
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });

            // Check if payment is completed
            _checkPaymentStatus(url);

            // Also inject JavaScript to monitor page content
            _injectPaymentDetectionScript();
          },
          onUrlChange: (UrlChange change) {
            if (change.url != null) {
              print('🔗 URL Changed: ${change.url}');
              _checkPaymentStatus(change.url!);
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('❌ WebView Error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _injectPaymentDetectionScript() {
    // Inject JavaScript to detect payment success messages in the page
    _controller.runJavaScript('''
      (function() {
        // Check for common success indicators in the page
        var bodyText = document.body ? document.body.innerText.toLowerCase() : '';
        var titleText = document.title ? document.title.toLowerCase() : '';
        var allText = bodyText + ' ' + titleText;
        
        var successKeywords = [
          'payment successful',
          'payment completed',
          'transaction successful',
          'transaction completed',
          'payment approved',
          'successful',
          'thank you',
          'payment verified',
          'success',
          'completed'
        ];
        
        for (var i = 0; i < successKeywords.length; i++) {
          if (allText.includes(successKeywords[i])) {
            // Send message to Flutter
            window.flutter_inappwebview.callHandler('paymentSuccess');
            return true;
          }
        }
        return false;
      })();
    ''');
  }

  void _checkPaymentStatus(String url) {
    if (_paymentCompleted) return; // Already processed

    print('🔍 Checking payment status for URL: $url');
    final lowerUrl = url.toLowerCase();

    // Check for common payment success indicators in URL
    final successIndicators = [
      'success',
      'completed',
      'approved',
      'verified',
      'transaction-successful',
      'payment-successful',
      'payment-completed',
      'transaction-completed',
      'thank-you',
      'thankyou',
    ];

    // Check if URL contains success indicators
    for (final indicator in successIndicators) {
      if (lowerUrl.contains(indicator)) {
        print('✅ Found success indicator in URL: $indicator');
        _handlePaymentSuccess();
        return;
      }
    }

    // Check for Paystack callback URLs with success status
    if (lowerUrl.contains('paystack.com')) {
      final uri = Uri.tryParse(url);
      if (uri != null) {
        // Check for status parameter
        final status = uri.queryParameters['status']?.toLowerCase();
        final reference = uri.queryParameters['reference'];

        print('📊 Paystack URL - Status: $status, Reference: $reference');

        if (status == 'success' ||
            status == 'approved' ||
            status == 'completed') {
          print('✅ Payment status is success');
          _handlePaymentSuccess();
          return;
        }

        // Check for callback URLs that typically indicate completion
        if (lowerUrl.contains('callback') ||
            lowerUrl.contains('verify') ||
            lowerUrl.contains('redirect') ||
            lowerUrl.contains('success') ||
            reference != null) {
          // Wait a bit and check page title and content
          Future.delayed(const Duration(milliseconds: 2000), () {
            if (!_paymentCompleted && mounted) {
              _controller.getTitle().then((title) {
                print('📄 Page title: $title');
                if (title != null && mounted) {
                  final lowerTitle = title.toLowerCase();
                  if (lowerTitle.contains('success') ||
                      lowerTitle.contains('approved') ||
                      lowerTitle.contains('completed') ||
                      lowerTitle.contains('thank you') ||
                      lowerTitle.contains('payment successful')) {
                    print('✅ Found success in page title');
                    _handlePaymentSuccess();
                  }
                }
              });
            }
          });
        }
      }
    }

    // Also check for any redirect URLs that might indicate completion
    if (lowerUrl.contains('redirect') || lowerUrl.contains('return')) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (!_paymentCompleted && mounted) {
          _controller.currentUrl().then((currentUrl) {
            if (currentUrl != null && mounted) {
              _checkPaymentStatus(currentUrl);
            }
          });
        }
      });
    }
  }

  void _handlePaymentSuccess() {
    if (_paymentCompleted) return;

    print('🎉 Payment completed! Closing sheet...');
    _paymentCompleted = true;

    // Close the sheet first, then call the callback
    if (mounted) {
      Navigator.of(context).pop();
      // Use microtask to ensure the sheet closes before calling callback
      Future.microtask(() {
        widget.onPaymentComplete();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'Complete Payment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                // Manual payment complete button
                TextButton(
                  onPressed: () {
                    if (mounted) {
                      Navigator.of(context).pop();
                      // Use microtask to ensure the sheet closes before calling callback
                      Future.microtask(() {
                        widget.onPaymentComplete();
                      });
                    }
                  },
                  child: const Text('Payment Done'),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          // WebView
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
