import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:authentication_otp_app/wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'OTP Authentication',
      home: Wrapper(title: '',),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }
}