import 'package:flutter/material.dart';
import 'package:proyecto_final/screens/onboarding_screen.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:google_fonts/google_fonts.dart';




class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: OnboardingScreen(),
      duration: 3000,
      imageSize: 130,
      imageSrc: "assets/logo.png",
      text: "Copa Mundial Qatar 2022",
      
      textType: TextType.ScaleAnimatedText,
      textStyle: TextStyle(
        fontSize: 30.0,
      ),
      backgroundColor: Colors.white,
    );
  }
}