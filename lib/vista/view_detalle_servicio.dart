import 'package:flutter/material.dart';

import '../estilo.dart';
import '../modelo/servicio.dart';
import 'appbar.dart';
import 'view_solicitud.dart';

class ViewDetalleServicio extends StatelessWidget {
  const ViewDetalleServicio({super.key, required this.servicio});
  final Servicio servicio;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar('Detalle del servicio'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(
            Icons.home_repair_service_outlined,
            size: 64,
            color: Estilo.colorAzul,
          ),
          const SizedBox(height: 24),
          Text(servicio.nombre, style: Estilo.textoencabezado),
          const SizedBox(height: 20),
          Text(servicio.descripcion, style: Estilo.textonormal),
          const SizedBox(height: 24),
          Text('Categoría: ${servicio.categoria}'),
          const SizedBox(height: 12),
          Text('Prestador: ${servicio.prestador}'),
          const SizedBox(height: 12),
          Text('Precio inicial: \$${servicio.precio.toStringAsFixed(0)} MXN'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => ViewSolicitud(servicio: servicio),
              ),
            ),
            child: const Text('Solicitar servicio'),
          ),
        ],
      ),
    );
  }
}
