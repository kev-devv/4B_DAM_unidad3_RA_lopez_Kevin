import 'package:sqflite/sqflite.dart';

class Prestador {
  String nombre;
  String especialidad;
  String descripcion;
  double calificacion;
  Prestador({
    required this.nombre,
    required this.especialidad,
    required this.descripcion,
    required this.calificacion,
  });

  static Future<List<Prestador>> all(Database db) async {
    final filas = await db.query('prestadores', orderBy: 'id_prestador');
    return filas
        .map(
          (fila) => Prestador(
            nombre: fila['nombre'] as String,
            especialidad: fila['especialidad'] as String,
            descripcion: fila['descripcion'] as String,
            calificacion: (fila['calificacion'] as num).toDouble(),
          ),
        )
        .toList();
  }
}
