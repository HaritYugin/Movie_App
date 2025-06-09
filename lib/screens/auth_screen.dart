
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/auth/auth_bloc.dart';
import 'package:movie_app/blocs/auth/auth_event.dart';
import 'package:movie_app/blocs/auth/auth_state.dart';
import 'package:movie_app/screens/home_screen.dart';
import 'package:shimmer/shimmer.dart';
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoginMode = true;
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.6),
          ),

          Center(
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthAuthenticated) {
                  _showSnackBar('Successfully ${_isLoginMode ? 'logged in' : 'registered'}!');
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                } else if (state is AuthError) {
                  _showSnackBar(state.message, isError: true);
                }
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: Colors.white.withOpacity(0.95),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo
                          Image.asset(
                            'assets/images/logo.png',
                            height: 80,
                            width: 80,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 16),

                          // App Title
                          Shimmer.fromColors(
                            baseColor: Colors.blue.shade900!,
                            highlightColor: Colors.white,
                            period: const Duration(milliseconds: 1500),
                            child: Text(
                              'Housefull My Show',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic,
                                color: Colors.blue.shade900,
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    color: Colors.white.withOpacity(0.5),
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Icon
                          Icon(
                            Icons.movie_filter,
                            size: 80,
                            color: Colors.blue.shade300,
                          ),
                          const SizedBox(height: 16),

                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              _isLoginMode ? 'Welcome Back!' : 'Join Us!',
                              key: ValueKey(_isLoginMode),
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.person),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Submit Button
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 5,
                                  ),
                                  onPressed: () {
                                    final username = _usernameController.text.trim();
                                    final password = _passwordController.text;

                                    if (username.isEmpty || password.isEmpty) {
                                      _showSnackBar(
                                          'Please enter both username and password.',
                                          isError: true);
                                      return;
                                    }

                                    if (_isLoginMode) {
                                      context.read<AuthBloc>().add(
                                        LoginRequested(
                                            username: username,
                                            password: password),
                                      );
                                    } else {
                                      context.read<AuthBloc>().add(
                                        RegisterRequested(
                                            username: username,
                                            password: password),
                                      );
                                    }
                                  },
                                  child: Text(
                                    _isLoginMode ? 'Login' : 'Register',
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // Toggle Login/Registration Mode
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLoginMode = !_isLoginMode;
                                _animationController.reset();
                                _animationController.forward();
                                _usernameController.clear();
                                _passwordController.clear();
                              });
                            },
                            child: Text(
                              _isLoginMode
                                  ? 'Don\'t have an account? Register'
                                  : 'Already have an account? Login',
                              style: TextStyle(color: Colors.blue.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}