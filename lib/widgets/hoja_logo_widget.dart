import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class HojaLogoWidget extends StatelessWidget {
  final double size;
  final bool isCircle;
  final bool showMetallicRing;

  const HojaLogoWidget({
    super.key,
    this.size = 76,
    this.isCircle = false,
    this.showMetallicRing = true,
  });

  @override
  Widget build(BuildContext context) {
    final radius = isCircle ? size / 2 : size * 0.22;
    return Container(
      width: size,
      height: size,
      padding: showMetallicRing ? const EdgeInsets.all(3) : EdgeInsets.zero,
      decoration: BoxDecoration(
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(radius + 3),
        gradient: showMetallicRing
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [HojaColors.primaryNavy, HojaColors.accentGold],
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: HojaColors.primaryNavy.withOpacity(0.22),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          color: Colors.white,
          child: Image.asset(
            'assets/images/hoja_logo.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Center(
              child: Icon(Icons.local_hospital_rounded, color: HojaColors.primaryNavy),
            ),
          ),
        ),
      ),
    );
  }
}
