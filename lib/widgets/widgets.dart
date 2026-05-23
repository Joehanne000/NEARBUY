import 'package:flutter/material.dart';
import '../theme.dart';

// ── Gradient Button ───────────────────────────────────────────────────────────
class NbButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;
  final List<Color> gradient;
  final IconData? icon;

  const NbButton({
    super.key,
    required this.label,
    this.onTap,
    this.loading = false,
    this.gradient = const [Color(0xFF4F8EF7), Color(0xFF7B5EA7)],
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: loading
              ? const SizedBox(width: 22, height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Row(mainAxisSize: MainAxisSize.min, children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(label, style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                ]),
        ),
      ),
    );
  }
}

// ── Text Field ────────────────────────────────────────────────────────────────
class NbField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  const NbField({
    super.key,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.keyboardType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NbColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NbColors.border),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(color: NbColors.textPrimary, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: NbColors.textSecondary, fontSize: 13),
          prefixIcon: Icon(icon, color: NbColors.textMuted, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────────────────────────
class NbStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const NbStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NbColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NbColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 12),
        Text(value, style: TextStyle(
            color: color, fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(
            color: NbColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

// ── Status Badge ──────────────────────────────────────────────────────────────
class NbBadge extends StatelessWidget {
  final String label;
  final Color color;

  const NbBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(.3)),
      ),
      child: Text(label, style: TextStyle(
          color: color, fontSize: 11, fontWeight: FontWeight.w700,
          letterSpacing: .5)),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────
class NbSectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const NbSectionHeader({
    super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(title, style: const TextStyle(
          color: NbColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
      const Spacer(),
      if (action != null)
        GestureDetector(
          onTap: onAction,
          child: Text(action!, style: const TextStyle(
              color: NbColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
        ),
    ]);
  }
}