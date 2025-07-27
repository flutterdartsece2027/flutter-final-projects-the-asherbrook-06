import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff426834),
      surfaceTint: Color(0xff426834),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffc2efad),
      onPrimaryContainer: Color(0xff2b4f1e),
      secondary: Color(0xff4b662c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffcdeda4),
      onSecondaryContainer: Color(0xff344e16),
      tertiary: Color(0xff526526),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffd4ec9d),
      onTertiaryContainer: Color(0xff3b4d0f),
      error: Color(0xff8c4e29),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdbca),
      onErrorContainer: Color(0xff6f3813),
      surface: Color(0xfff7fbf1),
      onSurface: Color(0xff191d17),
      onSurfaceVariant: Color(0xff424940),
      outline: Color(0xff72796f),
      outlineVariant: Color(0xffc2c9bd),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xffa7d293),
      primaryFixed: Color(0xffc2efad),
      onPrimaryFixed: Color(0xff042100),
      primaryFixedDim: Color(0xffa7d293),
      onPrimaryFixedVariant: Color(0xff2b4f1e),
      secondaryFixed: Color(0xffcdeda4),
      onSecondaryFixed: Color(0xff0f2000),
      secondaryFixedDim: Color(0xffb1d18a),
      onSecondaryFixedVariant: Color(0xff344e16),
      tertiaryFixed: Color(0xffd4ec9d),
      onTertiaryFixed: Color(0xff151f00),
      tertiaryFixedDim: Color(0xffb9cf84),
      onTertiaryFixedVariant: Color(0xff3b4d0f),
      surfaceDim: Color(0xffd8dbd2),
      surfaceBright: Color(0xfff7fbf1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ec),
      surfaceContainer: Color(0xffecefe6),
      surfaceContainerHigh: Color(0xffe6e9e0),
      surfaceContainerHighest: Color(0xffe0e4db),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff1a3e0f),
      surfaceTint: Color(0xff426834),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff507741),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff243d06),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff5a7539),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff2b3c00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff607433),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff5b2804),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff9e5d36),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7fbf1),
      onSurface: Color(0xff0e120d),
      onSurfaceVariant: Color(0xff323830),
      outline: Color(0xff4e544b),
      outlineVariant: Color(0xff686f65),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xffa7d293),
      primaryFixed: Color(0xff507741),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff395e2b),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff5a7539),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff425c23),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff607433),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff495b1d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc4c8bf),
      surfaceBright: Color(0xfff7fbf1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ec),
      surfaceContainer: Color(0xffe6e9e0),
      surfaceContainerHigh: Color(0xffdaded5),
      surfaceContainerHighest: Color(0xffcfd3ca),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff0f3305),
      surfaceTint: Color(0xff426834),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2d5221),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff1b3200),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff375018),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff233100),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff3d4f12),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4d1e00),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff723a16),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7fbf1),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff282e26),
      outlineVariant: Color(0xff444b42),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xffa7d293),
      primaryFixed: Color(0xff2d5221),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff163a0b),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff375018),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff213903),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff3d4f12),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff283800),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb6bab1),
      surfaceBright: Color(0xfff7fbf1),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff2e9),
      surfaceContainer: Color(0xffe0e4db),
      surfaceContainerHigh: Color(0xffd2d6cd),
      surfaceContainerHighest: Color(0xffc4c8bf),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa7d293),
      surfaceTint: Color(0xffa7d293),
      onPrimary: Color(0xff143809),
      primaryContainer: Color(0xff2b4f1e),
      onPrimaryContainer: Color(0xffc2efad),
      secondary: Color(0xffb1d18a),
      onSecondary: Color(0xff1f3701),
      secondaryContainer: Color(0xff344e16),
      onSecondaryContainer: Color(0xffcdeda4),
      tertiary: Color(0xffb9cf84),
      onTertiary: Color(0xff263500),
      tertiaryContainer: Color(0xff3b4d0f),
      onTertiaryContainer: Color(0xffd4ec9d),
      error: Color(0xffffb68e),
      onError: Color(0xff532201),
      errorContainer: Color(0xff6f3813),
      onErrorContainer: Color(0xffffdbca),
      surface: Color(0xff10140f),
      onSurface: Color(0xffe0e4db),
      onSurfaceVariant: Color(0xffc2c9bd),
      outline: Color(0xff8c9388),
      outlineVariant: Color(0xff424940),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4db),
      inversePrimary: Color(0xff426834),
      primaryFixed: Color(0xffc2efad),
      onPrimaryFixed: Color(0xff042100),
      primaryFixedDim: Color(0xffa7d293),
      onPrimaryFixedVariant: Color(0xff2b4f1e),
      secondaryFixed: Color(0xffcdeda4),
      onSecondaryFixed: Color(0xff0f2000),
      secondaryFixedDim: Color(0xffb1d18a),
      onSecondaryFixedVariant: Color(0xff344e16),
      tertiaryFixed: Color(0xffd4ec9d),
      onTertiaryFixed: Color(0xff151f00),
      tertiaryFixedDim: Color(0xffb9cf84),
      onTertiaryFixedVariant: Color(0xff3b4d0f),
      surfaceDim: Color(0xff10140f),
      surfaceBright: Color(0xff363a34),
      surfaceContainerLowest: Color(0xff0b0f0a),
      surfaceContainerLow: Color(0xff191d17),
      surfaceContainer: Color(0xff1d211b),
      surfaceContainerHigh: Color(0xff272b25),
      surfaceContainerHighest: Color(0xff323630),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbce9a8),
      surfaceTint: Color(0xffa7d293),
      onPrimary: Color(0xff082d01),
      primaryContainer: Color(0xff739c62),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffc6e79e),
      onSecondary: Color(0xff172b00),
      secondaryContainer: Color(0xff7c9a59),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffcee597),
      onTertiary: Color(0xff1d2a00),
      tertiaryContainer: Color(0xff839953),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd3bd),
      onError: Color(0xff431a00),
      errorContainer: Color(0xffc87f55),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff10140f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd8ded2),
      outline: Color(0xffadb4a9),
      outlineVariant: Color(0xff8c9288),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4db),
      inversePrimary: Color(0xff2c511f),
      primaryFixed: Color(0xffc2efad),
      onPrimaryFixed: Color(0xff021500),
      primaryFixedDim: Color(0xffa7d293),
      onPrimaryFixedVariant: Color(0xff1a3e0f),
      secondaryFixed: Color(0xffcdeda4),
      onSecondaryFixed: Color(0xff081400),
      secondaryFixedDim: Color(0xffb1d18a),
      onSecondaryFixedVariant: Color(0xff243d06),
      tertiaryFixed: Color(0xffd4ec9d),
      onTertiaryFixed: Color(0xff0c1400),
      tertiaryFixedDim: Color(0xffb9cf84),
      onTertiaryFixedVariant: Color(0xff2b3c00),
      surfaceDim: Color(0xff10140f),
      surfaceBright: Color(0xff41463f),
      surfaceContainerLowest: Color(0xff050805),
      surfaceContainerLow: Color(0xff1b1f19),
      surfaceContainer: Color(0xff252923),
      surfaceContainerHigh: Color(0xff2f342e),
      surfaceContainerHighest: Color(0xff3b3f39),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd0fdba),
      surfaceTint: Color(0xffa7d293),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa3cf90),
      onPrimaryContainer: Color(0xff010f00),
      secondary: Color(0xffdafbb0),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffadcd87),
      onSecondaryContainer: Color(0xff050e00),
      tertiary: Color(0xffe2f9a9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffb5cb80),
      onTertiaryContainer: Color(0xff070d00),
      error: Color(0xffffece4),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffb185),
      onErrorContainer: Color(0xff190600),
      surface: Color(0xff10140f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffecf2e6),
      outlineVariant: Color(0xffbec5b9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4db),
      inversePrimary: Color(0xff2c511f),
      primaryFixed: Color(0xffc2efad),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffa7d293),
      onPrimaryFixedVariant: Color(0xff021500),
      secondaryFixed: Color(0xffcdeda4),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb1d18a),
      onSecondaryFixedVariant: Color(0xff081400),
      tertiaryFixed: Color(0xffd4ec9d),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffb9cf84),
      onTertiaryFixedVariant: Color(0xff0c1400),
      surfaceDim: Color(0xff10140f),
      surfaceBright: Color(0xff4d514b),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1d211b),
      surfaceContainer: Color(0xff2d322c),
      surfaceContainerHigh: Color(0xff383d36),
      surfaceContainerHighest: Color(0xff444841),
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
