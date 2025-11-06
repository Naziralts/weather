import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/bloc/weather_event.dart';
import 'package:weather/core/colors.dart';
import 'package:weather/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required void Function() onToggleTheme}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Timer _timer;
  final String defaultCity = 'Bishkek';

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _startAnimations();
    _startTimer();
  }

  void _startAnimations() {
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    _slideController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 4), _navigateToHome);
  }

  void _navigateToHome() {
    if (mounted) {
      context.read<WeatherBloc>().add(FetchWeather(defaultCity));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WeatherAppHomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;

    final double titleFont = screenWidth < 400 ? 22 : 30;
    final double subTitleFont = screenWidth < 400 ? 16 : 20;
    final double imageHeight = screenHeight * 0.35;
    final double buttonFont = screenWidth < 400 ? 14 : 18;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.08,
              vertical: screenHeight * 0.05,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ✨ Текст с анимацией появления
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Text(
                      'Discover The\nWeather In Your City',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: titleFont,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),

                // ☁️ Анимированное появление картинки
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _slideController,
                        curve: Curves.easeOutBack,
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/cloudy.png',
                      height: imageHeight,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // 🔘 Нижний блок (текст + кнопка)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Get to know your weather maps and\nradar precipitation forecast',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: subTitleFont,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // Кнопка с мягкой анимацией
                      AnimatedScale(
                        scale: 1.0,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutBack,
                        child: SizedBox(
                          width: screenWidth > 500 ? 280 : screenWidth * 0.8,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              _timer.cancel();
                              _navigateToHome();
                            },
                            child: Text(
                              'Get Started',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: buttonFont,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
