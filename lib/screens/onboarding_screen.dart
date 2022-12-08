import 'package:flutter/material.dart';

import 'package:proyecto_final/screens/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';



class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {


  
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  Widget buildPage({
    required Color color,
    required String urlImage,
    required String title,
    required String subtitle,
  }) =>
  Container(
    color: color,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          urlImage,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        const SizedBox(height: 64),
        Text(
          title,
          style: TextStyle(
            color: Colors.teal.shade700,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            subtitle,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          padding: const EdgeInsets.only(bottom: 80),
          child: PageView(
            controller: controller,
            onPageChanged: (index){
              setState(() => isLastPage = index == 2);
            },
            children: [
              buildPage(
                color: Colors.purple.shade800,
                urlImage: 'assets/selecciones.jpg',
                title: '32 Selecciones...',
                subtitle: ''
              ),
              buildPage(
                color: Colors.orange.shade100,
                urlImage: 'assets/qatar.jpg',
                title: 'Un anfitrion',
                subtitle: ''
              ),
              buildPage(
                color: Colors.blue.shade100,
                urlImage: 'assets/copa.jpg',
                title: 'Una copa!',
                subtitle: ''
              ),         
            ],
          ),  
        ),
        bottomSheet: isLastPage ? TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0)
            ),
            primary: Colors.white,
            backgroundColor: Colors.teal.shade700,
            minimumSize: const Size.fromHeight(80)
          ),
          child: const Text(
            'Get Started',
            style: TextStyle(fontSize: 24),
          ),
          onPressed: () async {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        ) : Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text('SKIP'),
                onPressed: () => controller.jumpToPage(2),
              ),
              Center(
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 3,
                  onDotClicked: (index) => controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  ),
                ),
              ),
              TextButton(
                child: const Text('NEXT'),
                onPressed: () => controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                ),
              ),
            ],
          ),
        ),
      );
}
