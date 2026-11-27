import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';

class Actividad {
  final int id;
  String tipo;
  String servicio;
  String descripcion;
  String estado;
  String detalle;
  Actividad({
    required this.id,
    required this.tipo,
    required this.servicio,
    required this.descripcion,
    required this.estado,
    required this.detalle,
  });

  static Future<List<Actividad>> all(Database db, int idCliente) async {
    final filas = await db.rawQuery(
      '''
      SELECT a.*, s.nombre AS servicio
      FROM actividades a
      JOIN servicios s ON s.id_servicio = a.id_servicio
      WHERE a.id_cliente = ?
      ORDER BY a.id_actividad
    ''',
      [idCliente],
    );
    return filas
        .map(
          (fila) => Actividad(
            id: fila['id_actividad'] as int,
            tipo: fila['tipo'] as String,
            servicio: fila['servicio'] as String,
            descripcion: fila['descripcion'] as String,
            estado: fila['estado'] as String,
            detalle: fila['detalle'] as String,
          ),
        )
        .toList();
  }

  static Future<void> registraSolicitud(
    Database db, {
    required int idCliente,
    required int idServicio,
    required String descripcion,
    Uint8List? foto,
  }) async {
    await db.transaction((transaccion) async {
      final id = await transaccion.insert('actividades', {
        'id_cliente': idCliente,
        'id_servicio': idServicio,
        'tipo': 'Solicitudes',
        'descripcion': descripcion,
        'estado': 'Abierta',
        'detalle': foto == null ? 'Sin foto adjunta' : 'Con foto adjunta',
      });
      if (foto != null) {
        await transaccion.insert('fotos_solicitud', {
          'id_actividad': id,
          'imagen': foto,
        });
      }
    });
  }

  Future<Uint8List?> leeFoto(Database db) async {
    final filas = await db.query(
      'fotos_solicitud',
      columns: ['imagen'],
      where: 'id_actividad = ?',
      whereArgs: [id],
    );
    return filas.isEmpty ? null : filas.single['imagen'] as Uint8List;
  }
}
