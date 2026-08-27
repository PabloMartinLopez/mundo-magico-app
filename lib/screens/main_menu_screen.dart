import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mundomagico_wiki/widgets/BottomNavigationBar.dart';
import 'package:provider/provider.dart';

import '../providers/color_provider.dart';
import '../theme/MagicPatternBackground.dart';

/// Familia tipográfica para titulares. Declara una fuente en pubspec.yaml
/// (o usa google_fonts) y escribe aquí su nombre, p. ej. 'Cinzel'.
/// Con null se usa la fuente por defecto del sistema.
const String? kDisplayFont = null;

/// Peso visual de una opción dentro del menú.
/// - [primary]: destino principal, ancho completo y con sigilo animado.
/// - [secondary]: destinos habituales, en cuadrícula.
/// - [quiet]: acciones de servicio, al pie y sin caja.
enum MenuEmphasis { primary, secondary, quiet }

class MenuOption {
  const MenuOption({
    required this.label,
    required this.icon,
    required this.onTap,
    this.subtitle,
    this.emphasis = MenuEmphasis.secondary,
  });

  final String label;
  final String? subtitle;
  final IconData icon;
  final MenuEmphasis emphasis;
  final void Function(BuildContext context) onTap;
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  static const double _gap = 14;

  static final List<MenuOption> _options = [
    MenuOption(
      label: 'Characters',
      subtitle: 'Every witch, wizard and beast in the archive',
      icon: Icons.auto_stories_outlined,
      emphasis: MenuEmphasis.primary,
      onTap: (context) => Navigator.pushNamed(context, '/characters'),
    ),
    MenuOption(
      label: 'Houses',
      subtitle: 'Every witch, wizard and beast in the archive',
      icon: Icons.auto_stories_outlined,
      emphasis: MenuEmphasis.primary,
      onTap: (context) => Navigator.pushNamed(context, '/characters'),
    ),
    MenuOption(
      label: 'Configuration',
      subtitle: 'Colours, language and reading options',
      icon: Icons.tune,
      onTap: (context) => Navigator.pushNamed(context, '/options'),
    ),
    MenuOption(
      label: 'Close',
      icon: Icons.logout,
      emphasis: MenuEmphasis.quiet,
      onTap: (context) => SystemNavigator.pop(),
    ),
  ];

  int _columnsFor(int count, double width) {
    if (count <= 1) return 1;
    final maxByWidth = width >= 900 ? 4 : (width >= 600 ? 3 : 2);
    final maxByCount = count <= 4 ? 2 : 3;
    return math.min(count, math.min(maxByWidth, maxByCount));
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.watch<ColorProvider>().color;

    final primary = _options
        .where((o) => o.emphasis == MenuEmphasis.primary)
        .toList();
    final secondary = _options
        .where((o) => o.emphasis == MenuEmphasis.secondary)
        .toList();
    final quiet = _options
        .where((o) => o.emphasis == MenuEmphasis.quiet)
        .toList();

    return MagicPatternBackground(
      accent: accent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBar: Bottomnavigationbar(currentIndex: 1),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth - _gap * 2;
              final columns = _columnsFor(secondary.length, width);
              final tileWidth = (width - _gap * (columns - 1)) / columns;
              final tileHeight = columns == 1
                  ? 92.0
                  : (tileWidth * 0.92).clamp(112.0, 168.0);
              final heroWidth = (primary.length > 1 && width >= 800)
                  ? (width - _gap) / 2
                  : width;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(_gap, 0, _gap, _gap * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Masthead(accent: accent),
                    const SizedBox(height: _gap * 2),
                    if (primary.isNotEmpty)
                      Wrap(
                        spacing: _gap,
                        runSpacing: _gap,
                        children: [
                          for (final option in primary)
                            SizedBox(
                              width: heroWidth,
                              height: 148,
                              child: _MenuPlate(
                                option: option,
                                accent: accent,
                                showSigil: true,
                              ),
                            ),
                        ],
                      ),
                    if (primary.isNotEmpty && secondary.isNotEmpty)
                      const SizedBox(height: _gap),
                    if (secondary.isNotEmpty)
                      Wrap(
                        spacing: _gap,
                        runSpacing: _gap,
                        alignment: WrapAlignment.center,
                        children: [
                          for (final option in secondary)
                            SizedBox(
                              width: tileWidth,
                              height: tileHeight,
                              child: _MenuPlate(option: option, accent: accent),
                            ),
                        ],
                      ),
                    if (quiet.isNotEmpty) ...[
                      const SizedBox(height: _gap * 2),
                      _Rule(accent: accent),
                      const SizedBox(height: 4),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          for (final option in quiet)
                            _QuietAction(option: option),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Cabecera: antetítulo espaciado, título y regla partida por un rombo.
class _Masthead extends StatelessWidget {
  const _Masthead({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'THE WIKI',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 6,
            fontWeight: FontWeight.w500,
            color: accent.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Magic world',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: kDisplayFont,
            fontSize: 34,
            height: 1.1,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.5,
            color: Colors.white,
            shadows: [
              Shadow(color: accent.withValues(alpha: 0.5), blurRadius: 18),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _Rule(accent: accent),
      ],
    );
  }
}

/// Regla fina partida por un rombo en el centro.
class _Rule extends StatelessWidget {
  const _Rule({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(height: 1, color: accent.withValues(alpha: 0.35)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 6,
              height: 6,
              color: accent.withValues(alpha: 0.8),
            ),
          ),
        ),
        Expanded(
          child: Container(height: 1, color: accent.withValues(alpha: 0.35)),
        ),
      ],
    );
  }
}

/// Placa de opción. Cambia sola entre disposición en fila (placas anchas)
/// y en columna (placas cuadradas) según la forma que le toque.
class _MenuPlate extends StatefulWidget {
  const _MenuPlate({
    required this.option,
    required this.accent,
    this.showSigil = false,
  });

  final MenuOption option;
  final Color accent;
  final bool showSigil;

  @override
  State<_MenuPlate> createState() => _MenuPlateState();
}

class _MenuPlateState extends State<_MenuPlate>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 36),
  );
  bool _pressed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (widget.showSigil && !reduceMotion && !_spin.isAnimating) {
      _spin.repeat();
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accent;

    return AnimatedScale(
      scale: _pressed ? 0.98 : 1,
      duration: const Duration(milliseconds: 120),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: _pressed ? 0.42 : 0.3),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: accent.withValues(alpha: _pressed ? 0.85 : 0.35),
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: _pressed ? 0.35 : 0.12),
              blurRadius: _pressed ? 26 : 14,
              spreadRadius: _pressed ? 1 : 0,
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => widget.option.onTap(context),
            onHighlightChanged: (value) => setState(() => _pressed = value),
            splashColor: accent.withValues(alpha: 0.15),
            highlightColor: Colors.transparent,
            child: CustomPaint(
              painter: _CornerFiligree(
                color: accent.withValues(alpha: _pressed ? 0.9 : 0.55),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide =
                      constraints.maxWidth > constraints.maxHeight * 1.5;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: wide ? 20 : 14,
                      vertical: 14,
                    ),
                    child: wide ? _wideLayout() : _tallLayout(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _wideLayout() {
    return Row(
      children: [
        _emblem(56),
        const SizedBox(width: 18),
        Expanded(child: _labels(CrossAxisAlignment.start, TextAlign.start)),
        Icon(
          Icons.chevron_right,
          color: widget.accent.withValues(alpha: 0.8),
          size: 20,
        ),
      ],
    );
  }

  Widget _tallLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _emblem(48),
        const SizedBox(height: 12),
        _labels(CrossAxisAlignment.center, TextAlign.center),
      ],
    );
  }

  Widget _labels(CrossAxisAlignment cross, TextAlign align) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: cross,
      children: [
        Text(
          widget.option.label.toUpperCase(),
          textAlign: align,
          style: const TextStyle(
            fontFamily: kDisplayFont,
            fontSize: 15,
            letterSpacing: 2.4,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        if (widget.option.subtitle != null) ...[
          const SizedBox(height: 5),
          Text(
            widget.option.subtitle!,
            textAlign: align,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              height: 1.35,
              color: Colors.white.withValues(alpha: 0.62),
            ),
          ),
        ],
      ],
    );
  }

  /// Icono dentro del sigilo (o de un círculo fino si no lleva sigilo).
  Widget _emblem(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.showSigil)
            AnimatedBuilder(
              animation: _spin,
              builder: (context, _) => CustomPaint(
                size: Size.square(size),
                painter: _SigilPainter(
                  color: widget.accent,
                  rotation: _spin.value * 2 * math.pi,
                  glow: _pressed,
                ),
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.accent.withValues(alpha: 0.45),
                ),
              ),
            ),
          Icon(
            widget.option.icon,
            size: size * 0.42,
            color: Colors.white.withValues(alpha: 0.92),
          ),
        ],
      ),
    );
  }
}

/// Acción discreta al pie: solo texto espaciado, sin caja.
class _QuietAction extends StatelessWidget {
  const _QuietAction({required this.option});

  final MenuOption option;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => option.onTap(context),
      icon: Icon(option.icon, size: 15, color: Colors.white54),
      label: Text(
        option.label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          letterSpacing: 3,
          color: Colors.white54,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

/// Escuadras dobles en las cuatro esquinas, al estilo de una placa grabada.
class _CornerFiligree extends CustomPainter {
  _CornerFiligree({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const inset = 6.0;
    const arm = 14.0;
    const inner = 4.0;

    void corner(double x, double y, double dx, double dy) {
      canvas.drawPath(
        Path()
          ..moveTo(x + dx * arm, y)
          ..lineTo(x, y)
          ..lineTo(x, y + dy * arm),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(x + dx * (arm - 4), y + dy * inner)
          ..lineTo(x + dx * inner, y + dy * inner)
          ..lineTo(x + dx * inner, y + dy * (arm - 4)),
        paint,
      );
    }

    corner(inset, inset, 1, 1);
    corner(size.width - inset, inset, -1, 1);
    corner(inset, size.height - inset, 1, -1);
    corner(size.width - inset, size.height - inset, -1, -1);
  }

  @override
  bool shouldRepaint(_CornerFiligree old) => old.color != color;
}

/// Sigilo: tres arcos que giran muy despacio sobre una corona de marcas.
class _SigilPainter extends CustomPainter {
  _SigilPainter({
    required this.color,
    required this.rotation,
    required this.glow,
  });

  final Color color;
  final double rotation;
  final bool glow;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    final ring = Paint()
      ..color = color.withValues(alpha: glow ? 0.95 : 0.7)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius - 1);
    const sweep = (2 * math.pi / 3) - 0.5;
    for (var i = 0; i < 3; i++) {
      canvas.drawArc(rect, rotation + i * 2 * math.pi / 3, sweep, false, ring);
    }

    final ticks = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..strokeWidth = 1;
    for (var i = 0; i < 12; i++) {
      final angle = -rotation * 0.5 + i * math.pi / 6;
      final direction = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(
        center + direction * (radius * 0.68),
        center + direction * (radius * 0.78),
        ticks,
      );
    }
  }

  @override
  bool shouldRepaint(_SigilPainter old) =>
      old.rotation != rotation || old.color != color || old.glow != glow;
}
