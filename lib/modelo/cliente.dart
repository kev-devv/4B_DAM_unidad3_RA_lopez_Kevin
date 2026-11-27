import 'package:sqflite/sqflite.dart';

class Cliente {
  const Cliente({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.usuario,
    required this.ciudad,
  });

  final int id;
  final String nombre;
  final String correo;
  final String usuario;
  final String ciudad;

  // La app utiliza una cuenta local mientras se implementa el acceso.
  static Future<Cliente?> local(Database db) async {
    final filas = await db.query('clientes', orderBy: 'id_cliente', limit: 1);
    if (filas.isEmpty) return null;
    final fila = filas.single;
    return Cliente(
      id: fila['id_cliente'] as int,
      nombre: fila['nombre'] as String,
      correo: fila['correo'] as String,
      usuario: fila['usuario'] as String,
      ciudad: fila['ciudad'] as String,
    );
  }
}
