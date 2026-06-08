import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color blue = Color(0xFF0A84FF);
  static const Color coral = Color(0xFFFF453A);
  static const Color citrus = Color(0xFFFFD60A);
  static const Color mint = Color(0xFF30D158);
  static const Color violet = Color(0xFFBF5AF2);
  static const Color sky = Color(0xFF64D2FF);
}

class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.backgroundEnd,
    required this.glass,
    required this.glassStrong,
    required this.stroke,
    required this.text,
    required this.subtext,
    required this.cell,
    required this.selectedCell,
    required this.input,
    required this.shadow,
    required this.bottomGlass,
    required this.successSoft,
    required this.dangerSoft,
  });

  final Color background;
  final Color backgroundEnd;
  final Color glass;
  final Color glassStrong;
  final Color stroke;
  final Color text;
  final Color subtext;
  final Color cell;
  final Color selectedCell;
  final Color input;
  final Color shadow;
  final Color bottomGlass;
  final Color successSoft;
  final Color dangerSoft;

  @override
  AppPalette copyWith({
    Color? background,
    Color? backgroundEnd,
    Color? glass,
    Color? glassStrong,
    Color? stroke,
    Color? text,
    Color? subtext,
    Color? cell,
    Color? selectedCell,
    Color? input,
    Color? shadow,
    Color? bottomGlass,
    Color? successSoft,
    Color? dangerSoft,
  }) {
    return AppPalette(
      background: background ?? this.background,
      backgroundEnd: backgroundEnd ?? this.backgroundEnd,
      glass: glass ?? this.glass,
      glassStrong: glassStrong ?? this.glassStrong,
      stroke: stroke ?? this.stroke,
      text: text ?? this.text,
      subtext: subtext ?? this.subtext,
      cell: cell ?? this.cell,
      selectedCell: selectedCell ?? this.selectedCell,
      input: input ?? this.input,
      shadow: shadow ?? this.shadow,
      bottomGlass: bottomGlass ?? this.bottomGlass,
      successSoft: successSoft ?? this.successSoft,
      dangerSoft: dangerSoft ?? this.dangerSoft,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) {
      return this;
    }

    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      backgroundEnd: Color.lerp(backgroundEnd, other.backgroundEnd, t)!,
      glass: Color.lerp(glass, other.glass, t)!,
      glassStrong: Color.lerp(glassStrong, other.glassStrong, t)!,
      stroke: Color.lerp(stroke, other.stroke, t)!,
      text: Color.lerp(text, other.text, t)!,
      subtext: Color.lerp(subtext, other.subtext, t)!,
      cell: Color.lerp(cell, other.cell, t)!,
      selectedCell: Color.lerp(selectedCell, other.selectedCell, t)!,
      input: Color.lerp(input, other.input, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      bottomGlass: Color.lerp(bottomGlass, other.bottomGlass, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      dangerSoft: Color.lerp(dangerSoft, other.dangerSoft, t)!,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}

class AppTheme {
  const AppTheme._();

  static const _lightPalette = AppPalette(
    background: Color(0xFFF7F9FF),
    backgroundEnd: Color(0xFFEAF6FF),
    glass: Color(0xB8FFFFFF),
    glassStrong: Color(0xE8FFFFFF),
    stroke: Color(0x8FFFFFFF),
    text: Color(0xFF111827),
    subtext: Color(0xFF687588),
    cell: Color(0xAAFFFFFF),
    selectedCell: Color(0xFF111827),
    input: Color(0xD9FFFFFF),
    shadow: Color(0x2E2B3A67),
    bottomGlass: Color(0xDDF7FBFF),
    successSoft: Color(0x2630D158),
    dangerSoft: Color(0x24FF453A),
  );

  static const _darkPalette = AppPalette(
    background: Color(0xFF070A12),
    backgroundEnd: Color(0xFF111728),
    glass: Color(0x5C1F2937),
    glassStrong: Color(0xA6232D3D),
    stroke: Color(0x38FFFFFF),
    text: Color(0xFFF8FAFC),
    subtext: Color(0xFFB3BDCC),
    cell: Color(0x63232D3D),
    selectedCell: Color(0xFFEAF6FF),
    input: Color(0x85232D3D),
    shadow: Color(0x66000000),
    bottomGlass: Color(0xB30E1524),
    successSoft: Color(0x3330D158),
    dangerSoft: Color(0x33FF453A),
  );

  static ThemeData get light => _build(
        brightness: Brightness.light,
        palette: _lightPalette,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        palette: _darkPalette,
      );

  static ThemeData _build({
    required Brightness brightness,
    required AppPalette palette,
  }) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      brightness: brightness,
      primary: AppColors.blue,
      secondary: AppColors.coral,
      tertiary: AppColors.mint,
      surface: palette.background,
    );

    final textTheme = ThemeData(
      brightness: brightness,
      fontFamily: 'Roboto',
    ).textTheme.apply(
          bodyColor: palette.text,
          displayColor: palette.text,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      platform: TargetPlatform.iOS,
      colorScheme: scheme,
      extensions: const <ThemeExtension<dynamic>>[],
      scaffoldBackgroundColor: palette.background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: palette.text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: palette.text,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.input,
        labelStyle: TextStyle(color: palette.subtext),
        prefixIconColor: palette.subtext,
        suffixIconColor: palette.subtext,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: palette.stroke),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: palette.stroke),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: AppColors.blue, width: 1.8),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: isDark ? Colors.white : const Color(0xFF111827),
          foregroundColor: isDark ? const Color(0xFF111827) : Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.text,
          side: BorderSide(color: palette.stroke, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: palette.text,
          backgroundColor: palette.glass,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.blue;
          }

          return Colors.transparent;
        }),
        side: BorderSide(color: palette.subtext, width: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? palette.text
                : palette.glass;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? palette.background
                : palette.text;
          }),
          side: WidgetStatePropertyAll(BorderSide(color: palette.stroke)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        elevation: 0,
        highlightElevation: 2,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        indicatorColor:
            isDark ? const Color(0x33FFFFFF) : const Color(0x3347A3FF),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? palette.text
                : palette.subtext,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? Colors.white : const Color(0xFF111827),
        contentTextStyle: TextStyle(
          color: isDark ? const Color(0xFF111827) : Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        },
      ),
    ).copyWith(extensions: <ThemeExtension<dynamic>>[palette]);
  }
}
