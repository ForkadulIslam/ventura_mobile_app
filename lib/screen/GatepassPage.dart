import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GatepassPage extends StatefulWidget {
  final String? url;
  const GatepassPage({Key? key, @required this.url}) : super(key: key);

  @override
  _GatepassPageState createState() => _GatepassPageState();
}

class _GatepassPageState extends State<GatepassPage> {
  bool isLoading = true;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  void _handleLoad(String value) {
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  UniqueKey _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
            //index: _stackToView,
            children: [
              WebView(
                key: _key,
                initialUrl: widget.url.toString(),
                javascriptMode: JavascriptMode.unrestricted,
                onPageStarted: (_){
                },
                gestureNavigationEnabled: true,
                onPageFinished: _handleLoad,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                navigationDelegate: (NavigationRequest request) {
                  print('allowing navigation to $request');
                  return NavigationDecision.navigate;
                },
              ),
              isLoading ? Center( child: CircularProgressIndicator()) : Container(),
            ],
          ),
      ),
    );
  }
}


