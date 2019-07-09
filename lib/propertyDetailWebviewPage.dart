import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewContainer extends StatefulWidget {
  final String url;

  WebViewContainer({this.url});

  _WebViewContainerState createState() => _WebViewContainerState(url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  String _url;
  final _key = UniqueKey();

   _WebViewContainerState(this._url);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: Uri.dataFromString(
        _url,
        mimeType: 'text/html',
        parameters: {'charset': 'utf-8'},
        encoding: Encoding.getByName('utf-8'),
      ).toString(),
      withJavascript: true,
      enableAppScheme: true,
    );
  }

}
