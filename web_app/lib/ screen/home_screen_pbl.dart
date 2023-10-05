import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/platform_interface.dart';

class HomeScreenPBL extends StatelessWidget{
  WebViewController? controller;
  TextEditingController txtctr = TextEditingController();

  HomeScreenPBL({Key? key}): super(key:key);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        toolbarHeight: 80,
        title: Column(
          children: [
            Text(
              'SMP BROWSER',
              style: TextStyle(
                fontSize: 24,
                color: Colors.purple,
                fontWeight: FontWeight.w700
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    style: TextStyle(
                      fontSize: 18,height: 1,color:Colors.black,
                    ),
                    controller: txtctr,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xff7B8C4A),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)
                        )
                      )
                    ),
                  )
                ),
                IconButton(
                    onPressed: (){
                      if(controller!=null){
                        controller!.loadUrl(txtctr.text);
                      }
                    },
                    icon: Icon(
                      Icons.arrow_circle_right_outlined,
                      size:40,
                    )
                )
              ]
            ),
          ]
        ),
        centerTitle: true,
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