import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import 'datos_iniciales.dart';

class BD {
  static Future<Database> conexion() async {
    final directorio = await getDatabasesPath();
    return openDatabase(
      path.join(directorio, 'kindo_cliente.db'),
      version: 3,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE clientes (
            id_cliente INTEGER PRIMARY KEY,
            nombre TEXT NOT NULL,
            correo TEXT NOT NULL COLLATE NOCASE UNIQUE,
            usuario TEXT NOT NULL COLLATE NOCASE UNIQUE,
            ciudad TEXT NOT NULL
          )
        ''');

        // Datos públicos que se muestran en la pestaña Explorar.
        await db.execute('''
          CREATE TABLE prestadores (
            id_prestador INTEGER PRIMARY KEY,
            nombre TEXT NOT NULL,
            especialidad TEXT NOT NULL,
            descripcion TEXT NOT NULL,
            calificacion REAL NOT NULL CHECK (calificacion BETWEEN 0 AND 5)
          )
        ''');

        await db.execute('''
          CREATE TABLE servicios (
            id_servicio INTEGER PRIMARY KEY,
            id_prestador INTEGER NOT NULL REFERENCES prestadores(id_prestador),
            nombre TEXT NOT NULL,
            categoria TEXT NOT NULL,
            descripcion TEXT NOT NULL,
            precio REAL NOT NULL CHECK (precio >= 0)
          )
        ''');

        // Una sola tabla para las tres pestañas del modelo Actividad.
        await db.execute('''
          CREATE TABLE actividades (
            id_actividad INTEGER PRIMARY KEY,
            id_cliente INTEGER NOT NULL REFERENCES clientes(id_cliente),
            id_servicio INTEGER NOT NULL REFERENCES servicios(id_servicio),
            tipo TEXT NOT NULL CHECK (tipo IN ('Solicitudes', 'Cotizaciones', 'Trabajos')),
            descripcion TEXT NOT NULL,
            estado TEXT NOT NULL,
            detalle TEXT NOT NULL
          )
        ''');
        await _creaFotos(db);
        await cargaDatosIniciales(db);
      },
      onUpgrade: (db, versionAnterior, _) async {
        if (versionAnterior < 3) {
          await _creaFotos(db);
        }
        if (versionAnterior == 1) {
          final tablas = await db.rawQuery('''
            SELECT EXISTS(SELECT 1 FROM clientes)
                OR EXISTS(SELECT 1 FROM prestadores)
                OR EXISTS(SELECT 1 FROM servicios)
                OR EXISTS(SELECT 1 FROM actividades) AS tieneDatos
          ''');
          if (tablas.single['tieneDatos'] == 0) {
            await cargaDatosIniciales(db);
          }
        }
      },
    );
  }

  static Future<void> _creaFotos(Database db) => db.execute('''
    CREATE TABLE fotos_solicitud (
      id_actividad INTEGER PRIMARY KEY
        REFERENCES actividades(id_actividad) ON DELETE CASCADE,
      imagen BLOB NOT NULL
    )
  ''');
}
