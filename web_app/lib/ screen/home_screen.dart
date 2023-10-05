import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/platform_interface.dart';

class HomeScreen extends StatelessWidget{
  WebViewController? controller;

  HomeScreen({Key? key}): super(key:key);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('SMART MOBILE PROG'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed:(){
                if(controller !=null){
                  controller!.loadUrl('https://naver.com');
                }
            },
              icon: Icon(
                Icons.home,
              )
          )
        ],
      ),
      body: WebView(
        onWebViewCreated: (WebViewController controller){
          this.controller=controller;
        },
        initialUrl: 'https://naver.com',
        javascriptMode: JavascriptMode.unrestricted,
      ),

    );
  }
}