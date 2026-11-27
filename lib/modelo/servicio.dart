import 'package:sqflite/sqflite.dart';

class Servicio {
  int id;
  String nombre;
  String categoria;
  String prestador;
  String descripcion;
  double precio;
  Servicio({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.prestador,
    required this.descripcion,
    required this.precio,
  });

  static Future<List<Servicio>> all(Database db) async {
    final filas = await db.rawQuery('''
      SELECT s.*, p.nombre AS prestador
      FROM servicios s
      JOIN prestadores p ON p.id_prestador = s.id_prestador
      ORDER BY s.id_servicio
    ''');
    return filas
        .map(
          (fila) => Servicio(
            id: fila['id_servicio'] as int,
            nombre: fila['nombre'] as String,
            categoria: fila['categoria'] as String,
            prestador: fila['prestador'] as String,
            descripcion: fila['descripcion'] as String,
            precio: (fila['precio'] as num).toDouble(),
          ),
        )
        .toList();
  }
}
