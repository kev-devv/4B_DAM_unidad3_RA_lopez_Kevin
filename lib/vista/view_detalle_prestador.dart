import 'package:flutter/material.dart';
import '../estilo.dart';
import '../modelo/prestador.dart';
import 'appbar.dart';

class ViewDetallePrestador extends StatelessWidget {
  const ViewDetallePrestador({super.key, required this.prestador});
  final Prestador prestador;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar('Detalle del prestador'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(Icons.person_outline, size: 64, color: Estilo.colorAzul),
          const SizedBox(height: 24),
          Text(prestador.nombre, style: Estilo.textoencabezado),
          const SizedBox(height: 20),
          Text(prestador.especialidad, style: Estilo.textonormal),
          const SizedBox(height: 12),
          Text(prestador.descripcion),
          const SizedBox(height: 20),
          Text('Calificación: ${prestador.calificacion}'),
        ],
      ),
    );
  }
}
