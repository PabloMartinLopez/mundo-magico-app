import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Fondo con textura mágica abstracta.
///
/// Base casi negra + motivos dibujados en un único color de acento
/// ([accent]) que puedes cambiar en caliente: polvo suspendido, destellos
/// de cuatro puntas, fragmentos de órbita y volutas de humo.
///
/// No es un asset: se dibuja con [CustomPainter], así que no pixela, no
/// pesa nada en el bundle y el color es una variable normal.
///
/// Uso típico envolviendo una pantalla entera:
///
/// ```dart
/// MagicPatternBackground(
///   accent: MagicAccents.of(character.house),
///   child: Scaffold(
///     backgroundColor: Colors.transparent,
///     appBar: AppBar(backgroundColor: Colors.transparent),
///     body: ...,
///   ),
/// )
/// ```
class MagicPatternBackground extends StatelessWidget {
  const MagicPatternBackground({
    super.key,
    required this.accent,
    this.background = const Color(0xFF07070B),
    this.density = 1.0,
    this.seed = 7,
    this.child,
  });

  /// Color de todos los motivos. Cámbialo y cambia la textura entera.
  final Color accent;

  /// Color de la base. Casi negro por defecto.
  final Color background;

  /// Cantidad de motivos. 0.6 = discreto, 1.0 = normal, 1.6 = cargado.
  final double density;

  /// Misma semilla = mismo patrón siempre. Cámbiala para otra distribución.
  final int seed;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: MagicPatternPainter(
          accent: accent,
          background: background,
          density: density,
          seed: seed,
        ),
        isComplex: true,
        willChange: false,
        child: child,
      ),
    );
  }
}

/// Paleta de acentos lista para usar, por si quieres tintar el fondo
/// según la casa del personaje que estés mostrando.
abstract final class MagicAccents {
  static const neutral = Color(0xFF8E7CC3);

  static const _byHouse = <String, Color>{
    'Gryffindor': Color(0xFFD32525),
    'Slytherin': Color(0xFF2A9D6E),
    'Ravenclaw': Color(0xFF5D8AC7),
    'Hufflepuff': Color(0xFFE0A32E),
  };

  /// Devuelve [neutral] para casa vacía o desconocida.
  static Color of(String house) => _byHouse[house] ?? neutral;
}

class MagicPatternPainter extends CustomPainter {
  MagicPatternPainter({
    required this.accent,
    required this.background,
    this.density = 1.0,
    this.seed = 7,
  });

  final Color accent;
  final Color background;
  final double density;
  final int seed;

  /// Lado de la celda lógica. Cada celda decide sus propios motivos, así
  /// que el patrón no se repite nunca de forma visible.
  static const double _cell = 64;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1. Base: casi negro con una veladura del acento arriba, para que el
    //    fondo no sea plano y el color elegido se "note" aunque no mires
    //    los motivos.
    canvas.drawRect(rect, Paint()..color = background);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, -0.75),
          radius: 1.25,
          colors: [
            accent.withValues(alpha: 0.10),
            accent.withValues(alpha: 0.03),
            Colors.transparent,
          ],
          stops: const [0, 0.45, 1],
        ).createShader(rect),
    );

    // 2. Motivos, celda a celda. Un margen de una celda para que los
    //    elementos grandes puedan asomar por los bordes.
    final cols = (size.width / _cell).ceil() + 2;
    final rows = (size.height / _cell).ceil() + 2;

    for (var cy = -1; cy < rows; cy++) {
      for (var cx = -1; cx < cols; cx++) {
        _paintCell(canvas, cx, cy);
      }
    }
  }

  void _paintCell(Canvas canvas, int cx, int cy) {
    final rnd = math.Random(_hash(cx, cy, seed));
    final origin = Offset(cx * _cell, cy * _cell);

    // Polvo suspendido: siempre presente, es lo que da la textura.
    final motes = (3 + rnd.nextInt(4) * density).round();
    for (var i = 0; i < motes; i++) {
      final p =
          origin + Offset(rnd.nextDouble() * _cell, rnd.nextDouble() * _cell);
      final r = 0.5 + rnd.nextDouble() * 1.1;
      canvas.drawCircle(
        p,
        r,
        Paint()
          ..color = accent.withValues(alpha: 0.08 + rnd.nextDouble() * 0.18),
      );
    }

    // Destello de cuatro puntas con halo. Es el motivo protagonista, así
    // que va contado: aparece en una celda de cada cinco o seis.
    if (rnd.nextDouble() < 0.18 * density) {
      final c =
          origin + Offset(rnd.nextDouble() * _cell, rnd.nextDouble() * _cell);
      final r = 4 + rnd.nextDouble() * 9;
      final a = 0.28 + rnd.nextDouble() * 0.42;

      canvas.drawCircle(
        c,
        r * 1.6,
        Paint()
          ..shader = RadialGradient(
            colors: [accent.withValues(alpha: a * 0.35), Colors.transparent],
          ).createShader(Rect.fromCircle(center: c, radius: r * 1.6)),
      );

      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(rnd.nextDouble() * math.pi);
      canvas.drawPath(
        _sparkle(r),
        Paint()..color = accent.withValues(alpha: a),
      );
      canvas.restore();
    }

    // Fragmento de órbita: un arco finísimo de radio grande. Cruza varias
    // celdas y evita que la textura parezca una cuadrícula de puntos.
    if (rnd.nextDouble() < 0.07 * density) {
      final c =
          origin + Offset(rnd.nextDouble() * _cell, rnd.nextDouble() * _cell);
      final r = 40 + rnd.nextDouble() * 90;
      final start = rnd.nextDouble() * math.pi * 2;
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        start,
        0.5 + rnd.nextDouble() * 1.1,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.6 + rnd.nextDouble() * 0.5
          ..color = accent.withValues(alpha: 0.07 + rnd.nextDouble() * 0.09),
      );
    }

    // Voluta: una curva que se enrosca, como humo o un rastro de magia.
    if (rnd.nextDouble() < 0.05 * density) {
      final c =
          origin + Offset(rnd.nextDouble() * _cell, rnd.nextDouble() * _cell);
      final s = 18 + rnd.nextDouble() * 26;
      final dir = rnd.nextBool() ? 1.0 : -1.0;

      final path = Path()
        ..moveTo(c.dx, c.dy)
        ..cubicTo(
          c.dx + s * 0.9 * dir,
          c.dy - s * 0.2,
          c.dx + s * 1.0 * dir,
          c.dy - s * 1.0,
          c.dx + s * 0.15 * dir,
          c.dy - s * 1.0,
        )
        ..cubicTo(
          c.dx - s * 0.45 * dir,
          c.dy - s * 1.0,
          c.dx - s * 0.40 * dir,
          c.dy - s * 0.45,
          c.dx + s * 0.05 * dir,
          c.dy - s * 0.50,
        );

      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.7
          ..strokeCap = StrokeCap.round
          ..color = accent.withValues(alpha: 0.10 + rnd.nextDouble() * 0.10),
      );
    }
  }

  /// Estrella de cuatro puntas con los lados cóncavos, centrada en (0,0).
  Path _sparkle(double r) {
    final w = r * 0.16;
    return Path()
      ..moveTo(0, -r)
      ..quadraticBezierTo(w, -w, r, 0)
      ..quadraticBezierTo(w, w, 0, r)
      ..quadraticBezierTo(-w, w, -r, 0)
      ..quadraticBezierTo(-w, -w, 0, -r)
      ..close();
  }

  /// Hash determinista: la misma celda da siempre los mismos motivos,
  /// así el fondo no "hierve" al repintar ni al hacer scroll.
  int _hash(int x, int y, int seed) {
    var h = x * 374761393 + y * 668265263 + seed * 1274126177;
    h = (h ^ (h >> 13)) * 1274126177;
    return (h ^ (h >> 16)) & 0x7FFFFFFF;
  }

  @override
  bool shouldRepaint(MagicPatternPainter old) =>
      old.accent != accent ||
          old.background != background ||
          old.density != density ||
          old.seed != seed;
}