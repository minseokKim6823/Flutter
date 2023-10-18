import 'package:flutter/material.dart';
import 'package:week6_2/screen/home_screen.dart';
import 'package:week6_2/screen/settings_screen.dart';
import 'dart:math';
import 'package:shake/shake.dart';

class RootScreen extends StatefulWidget{
  const RootScreen({Key? key}): super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin{
  TabController? controller;
  double threshold =2.7;
  int number = 3;
  ShakeDetector? shakeDetector;
  @override
  void initState(){
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller!.addListener(tabListener);
    shakeDetector = ShakeDetector.autoStart(
      shakeSlopTimeMS: 100,
      shakeThresholdGravity: threshold,
      onPhoneShake: onPhoneShake,
    );
  }
  void onPhoneShake(){
    final rand =new Random();
    setState(() {
      number =rand.nextInt(5)+1;
    });
  }

  tabListener(){
    setState(() {});
  }

  @override
  dispose() {
    controller!.removeListener(tabListener);
    shakeDetector!.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: renderChildren(),
      ),
      bottomNavigationBar: renderBottomNavigation(),
    );
  }
  List<Widget> renderChildren(){
    return [
      HomeScreen(number: number),
      SettingsScreen(
        threshold: threshold,
        onThresholdChange: onThresholdChange,
      ),
    ];
  }

  void onThresholdChange(double val){
    setState(() {
      threshold =val;
    });
  }

  BottomNavigationBar renderBottomNavigation(){
    return BottomNavigationBar(
      currentIndex: controller!.index,
      onTap:  (int index){
        setState(() {
          //controller!.animateTo(index);
            if (index == 0) {
              // Switch to the '주사위' (Dice) tab
              controller!.animateTo(index);
            } else if (index == 1) {
              // Switch to the '설정' (Settings) tab
              controller!.animateTo(index);
            } else if (index == 2) {
              // Trigger the phone shake event when '굴리기' (Roll) is selected
              onPhoneShake();
            }
        });
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.edgesensor_high_outlined,
            ),
        label: '주사위',
        ),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
        label:'설정',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.start,
          ),
          label:'굴리기',
        ),
      ] ,

    );
  }
}
