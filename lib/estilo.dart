import 'package:flutter/material.dart';

// Colores y estilos de texto compartidos por las vistas de Kindo.
class Estilo {
  static const Color colorAzul = Color(0xFF2563EB);
  static const Color colorOscuro = Color(0xFF0B2D5B);
  static const Color colorVerde = Color(0xFF009D65);
  static const Color colorFondo = Color(0xFFF4F7FB);
  static const Color colorSuave = Color(0xFFEAF3FF);
  static const Color colorBlanco = Colors.white;
  static const Color colorTexto = Color(0xFF172033);
  static const Color colorSecundario = Color(0xFF64748B);
  static const Color colorBorde = Color(0xFFE2E8F0);
  static const TextStyle textotitulo = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: colorOscuro,
  );
  static const TextStyle textoencabezado = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: colorOscuro,
  );
  static const TextStyle textosubtitulo = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: colorOscuro,
  );
  static const TextStyle textonormal = TextStyle(
    fontSize: 16,
    height: 1.25,
    color: colorTexto,
  );
  static const TextStyle textochico = TextStyle(
    fontSize: 14,
    color: colorSecundario,
  );
  static final ButtonStyle estiloboton = ElevatedButton.styleFrom(
    backgroundColor: colorAzul,
    foregroundColor: colorBlanco,
    minimumSize: const Size(0, 52),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}
