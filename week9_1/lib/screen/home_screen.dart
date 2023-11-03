import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget{
  static final LatLng companyLatLng=LatLng(
      36.28341827,
      127.1791114,
  );
  const HomeScreen({Key? key}):super(key: key);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: renderAppBar(),
      body:GoogleMap(
        initialCameraPosition: CameraPosition(
          target: companyLatLng,
          zoom: 16,
        ),
      )
    );
  }
  AppBar renderAppBar(){
    return AppBar(
      title:Text(
        '오늘도 출근',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}