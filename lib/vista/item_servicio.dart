import 'package:flutter/material.dart';

import '../estilo.dart';
import '../modelo/servicio.dart';
import 'view_detalle_servicio.dart';

// Recibe un servicio para mostrar sus datos y abrir su detalle.
class ItemServicio extends StatelessWidget {
  const ItemServicio({super.key, required this.servicio});
  final Servicio servicio;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Estilo.colorBlanco,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const CircleAvatar(
          backgroundColor: Estilo.colorSuave,
          child: Icon(Icons.home_repair_service_outlined),
        ),
        title: Text(
          servicio.nombre,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Estilo.colorOscuro,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${servicio.categoria} · ${servicio.prestador}'),
            const SizedBox(height: 8),
            Text(
              'Desde \$${servicio.precio.toStringAsFixed(0)} MXN',
              style: const TextStyle(
                color: Estilo.colorAzul,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onTap: () {
          // Pasamos el objeto seleccionado a la pantalla de detalle.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewDetalleServicio(servicio: servicio),
            ),
          );
        },
      ),
    );
  }
}
