import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../estilo.dart';
import '../modelo/actividad.dart';
import '../modelo/bd.dart';
import 'appbar.dart';
import 'datos_sqlite.dart';

// Compartimos la pantalla porque los tres tipos muestran los mismos campos.
class ViewDetalleActividad extends StatelessWidget {
  const ViewDetalleActividad({super.key, required this.actividad});
  final Actividad actividad;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(actividad.tipo),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(actividad.servicio, style: Estilo.textoencabezado),
          const SizedBox(height: 24),
          Text(actividad.descripcion, style: Estilo.textonormal),
          const SizedBox(height: 16),
          Text(actividad.detalle),
          const SizedBox(height: 16),
          Text('Estado: ${actividad.estado}'),
          const SizedBox(height: 24),
          if (actividad.tipo == 'Solicitudes')
            DatosSqlite<Uint8List?>(
              cargar: () async => actividad.leeFoto(await BD.conexion()),
              contenido: (context, foto) => foto == null
                  ? const SizedBox.shrink()
                  : Image.memory(foto, semanticLabel: 'Foto de la solicitud'),
            ),
        ],
      ),
    );
  }
}
