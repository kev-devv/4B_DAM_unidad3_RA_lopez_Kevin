import 'package:flutter/material.dart';

import '../estilo.dart';

// La barra compartida mantiene el mismo estilo en las pantallas.
AppBar appbar(String title) {
  return AppBar(
    backgroundColor: Estilo.colorBlanco,
    foregroundColor: Estilo.colorOscuro,
    elevation: 0,
    scrolledUnderElevation: 0,
    surfaceTintColor: Estilo.colorBlanco,
    // En el panel principal usamos el logotipo; las otras vistas conservan su título.
    title: title == 'Kindo'
        ? Image.asset(
            'assets/imagenes/logo_kindo_claro.png',
            width: 120,
            height: 40,
            fit: BoxFit.contain,
            semanticLabel: 'Kindo',
          )
        : Text(title, style: Estilo.textoencabezado),
  );
}
