import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff6d5e0f),
      surfaceTint: Color(0xff6d5e0f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xfff7e388),
      onPrimaryContainer: Color(0xff534600),
      secondary: Color(0xff685f12),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfff1e48a),
      onSecondaryContainer: Color(0xff4f4700),
      tertiary: Color(0xff666014),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffefe58b),
      onTertiaryContainer: Color(0xff4e4800),
      error: Color(0xff8f4c34),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdbcf),
      onErrorContainer: Color(0xff72351f),
      surface: Color(0xfffef9eb),
      onSurface: Color(0xff1d1c14),
      onSurfaceVariant: Color(0xff49473a),
      outline: Color(0xff7a7768),
      outlineVariant: Color(0xffcbc7b5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff323128),
      inversePrimary: Color(0xffdac66f),
      primaryFixed: Color(0xfff7e388),
      onPrimaryFixed: Color(0xff211b00),
      primaryFixedDim: Color(0xffdac66f),
      onPrimaryFixedVariant: Color(0xff534600),
      secondaryFixed: Color(0xfff1e48a),
      onSecondaryFixed: Color(0xff201c00),
      secondaryFixedDim: Color(0xffd4c871),
      onSecondaryFixedVariant: Color(0xff4f4700),
      tertiaryFixed: Color(0xffefe58b),
      onTertiaryFixed: Color(0xff1f1c00),
      tertiaryFixedDim: Color(0xffd2c972),
      onTertiaryFixedVariant: Color(0xff4e4800),
      surfaceDim: Color(0xffdedacd),
      surfaceBright: Color(0xfffef9eb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f3e6),
      surfaceContainer: Color(0xfff2eee0),
      surfaceContainerHigh: Color(0xffece8da),
      surfaceContainerHighest: Color(0xffe7e2d5),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff403600),
      surfaceTint: Color(0xff6d5e0f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff7c6d1e),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3d3700),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff786e21),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3c3700),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff766f22),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff5d2510),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffa05a41),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffef9eb),
      onSurface: Color(0xff12110a),
      onSurfaceVariant: Color(0xff38372a),
      outline: Color(0xff555345),
      outlineVariant: Color(0xff706d5f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff323128),
      inversePrimary: Color(0xffdac66f),
      primaryFixed: Color(0xff7c6d1e),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff625403),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff786e21),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff5e5607),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff766f22),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff5c5608),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffcac6ba),
      surfaceBright: Color(0xfffef9eb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f3e6),
      surfaceContainer: Color(0xffece8da),
      surfaceContainerHigh: Color(0xffe1ddcf),
      surfaceContainerHighest: Color(0xffd6d1c4),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff342c00),
      surfaceTint: Color(0xff6d5e0f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff554900),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff322d00),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff524a00),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff312d00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff504a00),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff501c07),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff753821),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffef9eb),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff2e2c20),
      outlineVariant: Color(0xff4b493c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff323128),
      inversePrimary: Color(0xffdac66f),
      primaryFixed: Color(0xff554900),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff3c3200),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff524a00),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff393300),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff504a00),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff383400),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbcb9ac),
      surfaceBright: Color(0xfffef9eb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5f1e3),
      surfaceContainer: Color(0xffe7e2d5),
      surfaceContainerHigh: Color(0xffd8d4c7),
      surfaceContainerHighest: Color(0xffcac6ba),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffdac66f),
      surfaceTint: Color(0xffdac66f),
      onPrimary: Color(0xff393000),
      primaryContainer: Color(0xff534600),
      onPrimaryContainer: Color(0xfff7e388),
      secondary: Color(0xffd4c871),
      onSecondary: Color(0xff373100),
      secondaryContainer: Color(0xff4f4700),
      onSecondaryContainer: Color(0xfff1e48a),
      tertiary: Color(0xffd2c972),
      onTertiary: Color(0xff353100),
      tertiaryContainer: Color(0xff4e4800),
      onTertiaryContainer: Color(0xffefe58b),
      error: Color(0xffffb59b),
      onError: Color(0xff55200b),
      errorContainer: Color(0xff72351f),
      onErrorContainer: Color(0xffffdbcf),
      surface: Color(0xff14140c),
      onSurface: Color(0xffe7e2d5),
      onSurfaceVariant: Color(0xffcbc7b5),
      outline: Color(0xff949181),
      outlineVariant: Color(0xff49473a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe7e2d5),
      inversePrimary: Color(0xff6d5e0f),
      primaryFixed: Color(0xfff7e388),
      onPrimaryFixed: Color(0xff211b00),
      primaryFixedDim: Color(0xffdac66f),
      onPrimaryFixedVariant: Color(0xff534600),
      secondaryFixed: Color(0xfff1e48a),
      onSecondaryFixed: Color(0xff201c00),
      secondaryFixedDim: Color(0xffd4c871),
      onSecondaryFixedVariant: Color(0xff4f4700),
      tertiaryFixed: Color(0xffefe58b),
      onTertiaryFixed: Color(0xff1f1c00),
      tertiaryFixedDim: Color(0xffd2c972),
      onTertiaryFixedVariant: Color(0xff4e4800),
      surfaceDim: Color(0xff14140c),
      surfaceBright: Color(0xff3b3930),
      surfaceContainerLowest: Color(0xff0f0e07),
      surfaceContainerLow: Color(0xff1d1c14),
      surfaceContainer: Color(0xff212018),
      surfaceContainerHigh: Color(0xff2b2a21),
      surfaceContainerHighest: Color(0xff36352c),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff1dc82),
      surfaceTint: Color(0xffdac66f),
      onPrimary: Color(0xff2d2500),
      primaryContainer: Color(0xffa2913f),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffebde85),
      onSecondary: Color(0xff2b2600),
      secondaryContainer: Color(0xff9d9241),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffe8df86),
      onTertiary: Color(0xff2a2600),
      tertiaryContainer: Color(0xff9b9343),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd3c4),
      onError: Color(0xff471503),
      errorContainer: Color(0xffcb7d61),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff14140c),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffe1dcca),
      outline: Color(0xffb6b2a1),
      outlineVariant: Color(0xff949181),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe7e2d5),
      inversePrimary: Color(0xff544700),
      primaryFixed: Color(0xfff7e388),
      onPrimaryFixed: Color(0xff151100),
      primaryFixedDim: Color(0xffdac66f),
      onPrimaryFixedVariant: Color(0xff403600),
      secondaryFixed: Color(0xfff1e48a),
      onSecondaryFixed: Color(0xff141100),
      secondaryFixedDim: Color(0xffd4c871),
      onSecondaryFixedVariant: Color(0xff3d3700),
      tertiaryFixed: Color(0xffefe58b),
      onTertiaryFixed: Color(0xff141200),
      tertiaryFixedDim: Color(0xffd2c972),
      onTertiaryFixedVariant: Color(0xff3c3700),
      surfaceDim: Color(0xff14140c),
      surfaceBright: Color(0xff46453b),
      surfaceContainerLowest: Color(0xff080803),
      surfaceContainerLow: Color(0xff1f1e16),
      surfaceContainer: Color(0xff29281f),
      surfaceContainerHigh: Color(0xff34332a),
      surfaceContainerHighest: Color(0xff3f3e34),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff0b6),
      surfaceTint: Color(0xffdac66f),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffd6c36b),
      onPrimaryContainer: Color(0xff0f0b00),
      secondary: Color(0xfffff298),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffd0c46e),
      onSecondaryContainer: Color(0xff0e0b00),
      tertiary: Color(0xfffdf397),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffcec56f),
      onTertiaryContainer: Color(0xff0d0c00),
      error: Color(0xffffece6),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaf94),
      onErrorContainer: Color(0xff1d0400),
      surface: Color(0xff14140c),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfff5f0de),
      outlineVariant: Color(0xffc7c3b1),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe7e2d5),
      inversePrimary: Color(0xff544700),
      primaryFixed: Color(0xfff7e388),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffdac66f),
      onPrimaryFixedVariant: Color(0xff151100),
      secondaryFixed: Color(0xfff1e48a),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffd4c871),
      onSecondaryFixedVariant: Color(0xff141100),
      tertiaryFixed: Color(0xffefe58b),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffd2c972),
      onTertiaryFixedVariant: Color(0xff141200),
      surfaceDim: Color(0xff14140c),
      surfaceBright: Color(0xff525046),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff212018),
      surfaceContainer: Color(0xff323128),
      surfaceContainerHigh: Color(0xff3d3c32),
      surfaceContainerHighest: Color(0xff49473d),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
