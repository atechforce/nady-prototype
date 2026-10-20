import 'package:flutter/material.dart';

class NadyLogo extends StatelessWidget {
  const NadyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide;
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.primary,
                color.primary.withValues(alpha: 0.7),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: color.primary.withValues(alpha: 0.35),
                blurRadius: size * 0.22,
                spreadRadius: size * 0.02,
              ),
            ],
          ),
          child: Center(
            child: Icon(Icons.favorite, color: Colors.white, size: size * 0.5),
          ),
        );
      },
    );
  }
}