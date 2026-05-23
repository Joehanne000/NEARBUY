import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/widgets.dart';
import 'register_screen.dart';
import 'home_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        // Background glow
        Positioned(
          top: -120, left: -80,
          child: Container(
            width: 320, height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                NbColors.primary.withOpacity(.18),
                Colors.transparent,
              ]),
            ),
          ),
        ),
        Positioned(
          bottom: -80, right: -60,
          child: Container(
            width: 260, height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                NbColors.accent.withOpacity(.12),
                Colors.transparent,
              ]),
            ),
          ),
        ),

        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(children: [
              const SizedBox(height: 56),

              // Logo
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F8EF7), Color(0xFF7B5EA7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: NbColors.primary.withOpacity(.4),
                        blurRadius: 24, offset: const Offset(0, 8)),
                  ],
                ),
                child: const Icon(Icons.storefront_rounded,
                    color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              const Text('NearBuy', style: TextStyle(
                  color: NbColors.textPrimary, fontSize: 34,
                  fontWeight: FontWeight.w800, letterSpacing: -1.2)),
              const SizedBox(height: 6),
              const Text('Your neighborhood, delivered.',
                  style: TextStyle(color: NbColors.textSecondary, fontSize: 14)),

              const SizedBox(height: 48),

              // Form card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: NbColors.card,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: NbColors.border),
                ),
                child: Column(children: [
                  const NbField(label: 'Email address',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  const NbField(label: 'Password',
                      icon: Icons.lock_outline_rounded, obscure: true),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Forgot password?',
                          style: TextStyle(color: NbColors.primary, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  NbButton(
                    label: 'Sign In',
                    onTap: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const HomeRouter())),
                  ),
                  const SizedBox(height: 16),
                  Row(children: const [
                    Expanded(child: Divider(color: NbColors.border)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('or', style: TextStyle(color: NbColors.textMuted, fontSize: 12)),
                    ),
                    Expanded(child: Divider(color: NbColors.border)),
                  ]),
                  const SizedBox(height: 16),
                  _googleButton(context),
                ]),
              ),

              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Don't have an account? ",
                    style: TextStyle(color: NbColors.textSecondary, fontSize: 14)),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen())),
                  child: const Text('Register',
                      style: TextStyle(color: NbColors.primary,
                          fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ]),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _googleButton(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: NbColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: NbColors.border),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 20, height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Center(
              child: Text('G', style: TextStyle(
                  color: Color(0xFF4285F4), fontWeight: FontWeight.w800,
                  fontSize: 13))),
          ),
          const SizedBox(width: 10),
          const Text('Continue with Google',
              style: TextStyle(color: NbColors.textPrimary,
                  fontWeight: FontWeight.w600, fontSize: 14)),
        ]),
      ),
    );
  }
}