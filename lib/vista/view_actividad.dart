import 'package:flutter/material.dart';

import '../estilo.dart';
import '../modelo/bd.dart';
import '../modelo/cliente.dart';
import 'datos_sqlite.dart';
import '../modelo/actividad.dart';
import 'appbar.dart';
import 'item_actividad.dart';

class ViewActividad extends StatelessWidget {
  const ViewActividad({
    super.key,
    this.enPanel = false,
    this.seccionInicial = 0,
  });
  final bool enPanel;
  final int seccionInicial;
  @override
  Widget build(BuildContext context) {
    // TabBar y TabBarView coordinan las tres secciones de actividad.
    return DefaultTabController(
      length: 3,
      initialIndex: seccionInicial,
      child: Scaffold(
        appBar: enPanel ? null : appbar('Mi actividad'),
        body: DatosSqlite(cargar: _cargar, contenido: _body),
      ),
    );
  }

  Future<List<Actividad>> _cargar() async {
    final db = await BD.conexion();
    final cliente = await Cliente.local(db);
    return cliente == null ? [] : Actividad.all(db, cliente.id);
  }

  Widget _body(BuildContext context, List<Actividad> actividades) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mi actividad', style: Estilo.textotitulo),
              SizedBox(height: 8),
              Text(
                'Consulta el seguimiento de tus servicios.',
                style: Estilo.textochico,
              ),
            ],
          ),
        ),
        const TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: Estilo.colorAzul,
          tabs: [
            Tab(text: 'Solicitudes'),
            Tab(text: 'Cotizaciones'),
            Tab(text: 'Trabajos'),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              _lista(actividades, 'Solicitudes'),
              _lista(actividades, 'Cotizaciones'),
              _lista(actividades, 'Trabajos'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _lista(List<Actividad> actividades, String tipo) {
    final registros = actividades
        .where((actividad) => actividad.tipo == tipo)
        .toList();
    if (registros.isEmpty) {
      return const Center(child: Text('No hay registros en esta sección.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: registros.length,
      itemBuilder: (context, index) {
        return ItemActividad(actividad: registros.elementAt(index));
      },
    );
  }
}
