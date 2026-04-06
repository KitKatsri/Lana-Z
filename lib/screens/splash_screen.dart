import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.15),
            radius: 1.6,
            colors: [Color(0xFF1B0E3A), AppColors.background],
            stops: [0.0, 0.75],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final glow = 0.2 + (_pulseController.value * 0.2);
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.lavender.withOpacity(glow),
                              blurRadius: 80,
                              spreadRadius: 20,
                            ),
                            BoxShadow(
                              color: AppColors.softPink.withOpacity(glow * 0.6),
                              blurRadius: 120,
                              spreadRadius: 40,
                            ),
                          ],
                        ),
                      ),
                      child!,
                    ],
                  );
                },
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.accentGradient,
                  ),
                  child: const Icon(
                    Icons.music_note_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.4, 0.4),
                    end: const Offset(1.0, 1.0),
                    duration: 900.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 500.ms),
              const SizedBox(height: 40),
              Text(
                'LANA Z',
                style: Theme.of(context).textTheme.displayLarge,
              )
                  .animate(delay: 450.ms)
                  .fadeIn(duration: 900.ms)
                  .slideY(begin: 0.35, end: 0, curve: Curves.easeOut),
              const SizedBox(height: 10),
              Text(
                'dream in sound',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(letterSpacing: 5),
              ).animate(delay: 900.ms).fadeIn(duration: 700.ms),
              const SizedBox(height: 72),
              SizedBox(
                width: 48,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: const LinearProgressIndicator(
                    backgroundColor: AppColors.textHint,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.lavender),
                    minHeight: 2,
                  ),
                ),
              ).animate(delay: 1100.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}
