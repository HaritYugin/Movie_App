import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/auth/auth_bloc.dart';
import 'package:movie_app/blocs/auth/auth_event.dart';
import 'package:movie_app/blocs/auth/auth_state.dart';
import 'package:movie_app/screens/auth_screen.dart';
import 'package:movie_app/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 6), () {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthScreen()),
        );
      }
    });

    context.read<AuthBloc>().add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: SizedBox.expand(
          child: Image.asset(
            'assets/images/mov.gif',
            fit: BoxFit.cover,
            gaplessPlayback: true,
          ),
        ),
      ),
    ),
    );
  }
}
