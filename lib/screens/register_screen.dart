import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/widgets.dart';
import 'home_router.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Positioned(
          top: -100, right: -80,
          child: Container(
            width: 280, height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                NbColors.accent.withOpacity(.15),
                Colors.transparent,
              ]),
            ),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 16),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: NbColors.textSecondary, size: 20),
              ),
              const SizedBox(height: 24),
              const Text('Create Account', style: TextStyle(
                  color: NbColors.textPrimary, fontSize: 30,
                  fontWeight: FontWeight.w800, letterSpacing: -.8)),
              const SizedBox(height: 6),
              const Text('Join NearBuy and shop local.',
                  style: TextStyle(color: NbColors.textSecondary, fontSize: 14)),
              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: NbColors.card,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: NbColors.border),
                ),
                child: Column(children: [
                  const NbField(label: 'Full name', icon: Icons.person_outline_rounded),
                  const SizedBox(height: 12),
                  const NbField(label: 'Email address',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  const NbField(label: 'Password',
                      icon: Icons.lock_outline_rounded, obscure: true),
                  const SizedBox(height: 12),
                  const NbField(label: 'Confirm password',
                      icon: Icons.lock_outline_rounded, obscure: true),
                  const SizedBox(height: 20),

                  // Role selector
                  _RoleSelector(),
                  const SizedBox(height: 20),

                  NbButton(
                    label: 'Create Account',
                    icon: Icons.arrow_forward_rounded,
                    gradient: const [Color(0xFF00D4AA), Color(0xFF4F8EF7)],
                    onTap: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const HomeRouter())),
                  ),
                ]),
              ),

              const SizedBox(height: 24),
              Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('Already have an account? ',
                    style: TextStyle(color: NbColors.textSecondary, fontSize: 14)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Sign In',
                      style: TextStyle(color: NbColors.primary,
                          fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ])),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _RoleSelector extends StatefulWidget {
  @override
  State<_RoleSelector> createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<_RoleSelector> {
  String _selected = 'BUYER';

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('I am a...', style: TextStyle(
          color: NbColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _option('BUYER', Icons.shopping_bag_outlined, 'Buyer')),
        const SizedBox(width: 10),
        Expanded(child: _option('STORE_OWNER', Icons.store_outlined, 'Store Owner')),
      ]),
    ]);
  }

  Widget _option(String value, IconData icon, String label) {
    final selected = _selected == value;
    return GestureDetector(
      onTap: () => setState(() => _selected = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? NbColors.primary.withOpacity(.12) : NbColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? NbColors.primary : NbColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(children: [
          Icon(icon, color: selected ? NbColors.primary : NbColors.textMuted, size: 22),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(
              color: selected ? NbColors.primary : NbColors.textSecondary,
              fontSize: 12, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}