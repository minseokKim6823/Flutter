import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen2 extends StatefulWidget{
  const HomeScreen2({Key? key}) : super(key: key);

  @override
  State<HomeScreen2> createState() => _HomeScreenState();
  //State를 반환받기 위해서 createState() 반드시 정의 필요
}

class _HomeScreenState extends State<HomeScreen2> {
  final PageController pageController = PageController();
  bool count=true;
  @override
  void initState() {
    super.initState(); //반드시 부모의 initState() 호출
    Timer.periodic(
        Duration(seconds: 3),
            (timer) {
              int? nextPage = pageController.page?.toInt();
              if (nextPage == null) {
                return;
              }
              if (nextPage == 5) {
                nextPage--;
                count=false;
              }
              else if(count==true) {
                nextPage++;
                // if(nextPage==5){
                //   count=false;
                //   print(nextPage)
                //}
              }
              else if(count == false){
                nextPage--;
                if(nextPage==0){
                  count=true;
                }
              }

              pageController.animateToPage(nextPage, duration: Duration(milliseconds: 1000),
                curve: Curves.ease,
              );
            }
    );
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [1,2,3,4,5,6]
            .map(
              (number) => Image.asset('asset/img/img$number.jpg',
            fit: BoxFit.cover,
          ),
        ).toList(),
      ),
    );
  }
}

