import 'package:flutter/material.dart';

import '../estilo.dart';
import '../modelo/actividad.dart';
import 'view_detalle_actividad.dart';

// Una tarjeta reutilizada para solicitudes, cotizaciones y trabajos.
class ItemActividad extends StatelessWidget {
  const ItemActividad({super.key, required this.actividad});
  final Actividad actividad;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Estilo.colorBlanco,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          actividad.servicio,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Estilo.colorOscuro,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(actividad.descripcion),
            const SizedBox(height: 8),
            Text(
              'Estado: ${actividad.estado}',
              style: const TextStyle(color: Estilo.colorVerde),
            ),
            const SizedBox(height: 8),
            Text(actividad.detalle),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewDetalleActividad(actividad: actividad),
            ),
          );
        },
      ),
    );
  }
}
