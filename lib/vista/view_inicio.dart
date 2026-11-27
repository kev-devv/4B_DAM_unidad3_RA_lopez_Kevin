import 'package:flutter/material.dart';

import '../estilo.dart';
import '../modelo/actividad.dart';
import '../modelo/bd.dart';
import '../modelo/cliente.dart';
import '../modelo/servicio.dart';
import 'datos_sqlite.dart';
import 'item_servicio.dart';
import 'view_actividad.dart';

class ViewInicio extends StatelessWidget {
  const ViewInicio({super.key});
  @override
  Widget build(BuildContext context) {
    return DatosSqlite(
      cargar: _cargar,
      contenido: (context, datos) =>
          _body(context, datos.servicios, datos.cliente, datos.actividades),
    );
  }

  Future<
    ({List<Servicio> servicios, Cliente? cliente, List<Actividad> actividades})
  >
  _cargar() async {
    final db = await BD.conexion();
    final cliente = await Cliente.local(db);
    return (
      servicios: await Servicio.all(db),
      cliente: cliente,
      actividades: cliente == null
          ? <Actividad>[]
          : await Actividad.all(db, cliente.id),
    );
  }

  Widget _body(
    BuildContext context,
    List<Servicio> servicios,
    Cliente? cliente,
    List<Actividad> actividades,
  ) {
    final solicitudes = actividades
        .where((a) => a.tipo == 'Solicitudes')
        .length;
    final cotizaciones = actividades
        .where((a) => a.tipo == 'Cotizaciones')
        .length;
    final trabajos = actividades.where((a) => a.tipo == 'Trabajos').length;
    final pendientes = actividades
        .where((a) => a.tipo == 'Cotizaciones' && a.estado == 'Pendiente')
        .length;
    // ListView permite desplazar todo el contenido cuando no cabe en el teléfono.
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Servicios locales en Ocosingo', style: Estilo.textochico),
        const SizedBox(height: 12),
        const Text(
          'Encuentra el servicio que necesitas en Ocosingo.',
          style: Estilo.textotitulo,
        ),
        const SizedBox(height: 12),
        const Text(
          'Personas confiables, servicios de calidad, más cerca de ti.',
          style: Estilo.textonormal,
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          style: Estilo.estiloboton,
          icon: const Icon(Icons.search),
          label: const Text('Buscar servicios'),
          onPressed: () {
            Navigator.pushNamed(context, '/explorar');
          },
        ),
        const SizedBox(height: 20),
        Image.asset(
          'assets/imagenes/cliente_plomero.png',
          height: 210,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 24),
        if (cliente != null)
          Text('Hola, ${cliente.nombre}', style: Estilo.textoencabezado),
        const Text(
          'Consulta tus servicios y sigue tu actividad.',
          style: Estilo.textochico,
        ),
        const SizedBox(height: 20),
        _resumen(
          context,
          'Mis solicitudes',
          '$solicitudes registradas',
          Icons.assignment_outlined,
          0,
        ),
        _resumen(
          context,
          'Cotizaciones',
          '$cotizaciones recibidas',
          Icons.request_quote_outlined,
          1,
        ),
        _resumen(
          context,
          'Trabajos',
          '$trabajos en historial',
          Icons.receipt_long_outlined,
          2,
        ),
        if (pendientes > 0) ...[
          const SizedBox(height: 24),
          const Text('Novedad', style: Estilo.textoencabezado),
          Card(
            color: Estilo.colorSuave,
            child: ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: Text(
                pendientes == 1
                    ? 'Tienes una cotización pendiente'
                    : 'Tienes $pendientes cotizaciones pendientes',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ViewActividad(seccionInicial: 1),
                  ),
                );
              },
            ),
          ),
        ],
        const SizedBox(height: 24),
        const Text('Servicios cerca de ti', style: Estilo.textoencabezado),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/explorar');
          },
          child: const Text('Ver todos'),
        ),
        // Reutilizamos la misma tarjeta que aparece en Explorar.
        if (servicios.isEmpty) const Text('No hay servicios disponibles.'),
        for (final servicio in servicios.take(2))
          ItemServicio(servicio: servicio),
      ],
    );
  }

  Widget _resumen(
    BuildContext context,
    String titulo,
    String detalle,
    IconData icono,
    int seccion,
  ) {
    return Card(
      color: Estilo.colorBlanco,
      child: ListTile(
        leading: Icon(icono, color: Estilo.colorAzul),
        title: Text(titulo),
        subtitle: Text(detalle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewActividad(seccionInicial: seccion),
            ),
          );
        },
      ),
    );
  }
}
