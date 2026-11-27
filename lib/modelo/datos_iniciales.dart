import 'package:sqflite/sqflite.dart';

Future<void> cargaDatosIniciales(Database db) async {
  final batch = db.batch();
  batch.insert('clientes', {
    'id_cliente': 1,
    'nombre': 'María González',
    'correo': 'cliente@kindo.demo',
    'usuario': 'cliente',
    'ciudad': 'Ocosingo, Chiapas',
  });
  batch.insert('prestadores', {
    'id_prestador': 1,
    'nombre': 'Carlos Méndez',
    'especialidad': 'Electricidad',
    'descripcion': 'Instalaciones y reparaciones.',
    'calificacion': 4.8,
  });
  batch.insert('prestadores', {
    'id_prestador': 2,
    'nombre': 'María Hernández',
    'especialidad': 'Plomería',
    'descripcion': 'Fugas y mantenimiento.',
    'calificacion': 4.9,
  });
  batch.insert('prestadores', {
    'id_prestador': 3,
    'nombre': 'José Pérez',
    'especialidad': 'Pintura',
    'descripcion': 'Acabados para el hogar.',
    'calificacion': 4.7,
  });
  batch.insert('prestadores', {
    'id_prestador': 4,
    'nombre': 'Ana Ruiz',
    'especialidad': 'Carpintería',
    'descripcion': 'Muebles y reparaciones.',
    'calificacion': 4.9,
  });
  batch.insert('prestadores', {
    'id_prestador': 5,
    'nombre': 'Luis Gómez',
    'especialidad': 'Tecnología',
    'descripcion': 'Equipos y redes.',
    'calificacion': 4.8,
  });
  batch.insert('servicios', {
    'id_servicio': 1,
    'id_prestador': 1,
    'nombre': 'Instalación eléctrica',
    'categoria': 'Electricidad',
    'descripcion': 'Instalación y revisión eléctrica para el hogar.',
    'precio': 350,
  });
  batch.insert('servicios', {
    'id_servicio': 2,
    'id_prestador': 2,
    'nombre': 'Reparación de fugas',
    'categoria': 'Plomería',
    'descripcion': 'Detección y reparación de fugas de agua.',
    'precio': 280,
  });
  batch.insert('servicios', {
    'id_servicio': 3,
    'id_prestador': 3,
    'nombre': 'Pintura de interiores',
    'categoria': 'Pintura',
    'descripcion': 'Pintura y retoques para habitaciones.',
    'precio': 500,
  });
  batch.insert('servicios', {
    'id_servicio': 4,
    'id_prestador': 4,
    'nombre': 'Muebles a medida',
    'categoria': 'Carpintería',
    'descripcion': 'Diseño y reparación de muebles de madera.',
    'precio': 650,
  });
  batch.insert('servicios', {
    'id_servicio': 5,
    'id_prestador': 5,
    'nombre': 'Soporte de computadoras',
    'categoria': 'Tecnología',
    'descripcion': 'Diagnóstico y mantenimiento de equipos.',
    'precio': 300,
  });
  batch.insert('actividades', {
    'id_actividad': 1,
    'id_cliente': 1,
    'id_servicio': 2,
    'tipo': 'Solicitudes',
    'descripcion': 'Fuga en la cocina',
    'estado': 'Abierta',
    'detalle': 'Ubicación: Centro, Ocosingo',
  });
  batch.insert('actividades', {
    'id_actividad': 2,
    'id_cliente': 1,
    'id_servicio': 1,
    'tipo': 'Solicitudes',
    'descripcion': 'Revisar contactos',
    'estado': 'En revisión',
    'detalle': 'Ubicación: Barrio Norte, Ocosingo',
  });
  batch.insert('actividades', {
    'id_actividad': 3,
    'id_cliente': 1,
    'id_servicio': 2,
    'tipo': 'Cotizaciones',
    'descripcion': 'Prestador: María Hernández',
    'estado': 'Pendiente',
    'detalle': 'Precio propuesto: \$320 MXN',
  });
  batch.insert('actividades', {
    'id_actividad': 4,
    'id_cliente': 1,
    'id_servicio': 1,
    'tipo': 'Cotizaciones',
    'descripcion': 'Prestador: Carlos Méndez',
    'estado': 'Aceptada',
    'detalle': 'Precio propuesto: \$420 MXN',
  });
  batch.insert('actividades', {
    'id_actividad': 5,
    'id_cliente': 1,
    'id_servicio': 1,
    'tipo': 'Trabajos',
    'descripcion': 'Prestador: Carlos Méndez',
    'estado': 'En proceso',
    'detalle': 'Seguimiento de trabajo de ejemplo',
  });
  batch.insert('actividades', {
    'id_actividad': 6,
    'id_cliente': 1,
    'id_servicio': 3,
    'tipo': 'Trabajos',
    'descripcion': 'Prestador: José Pérez',
    'estado': 'Finalizada',
    'detalle': 'Seguimiento de trabajo de ejemplo',
  });
  await batch.commit(noResult: true);
}
