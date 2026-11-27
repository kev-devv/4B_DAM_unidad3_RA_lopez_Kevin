import 'package:flutter/material.dart';

import '../estilo.dart';
import '../modelo/bd.dart';
import 'datos_sqlite.dart';
import '../modelo/servicio.dart';
import '../modelo/prestador.dart';
import 'appbar.dart';
import 'item_servicio.dart';
import 'item_prestador.dart';

// Presenta el catálogo y permite navegar entre sus pestañas.
class ViewExplorar extends StatelessWidget {
  const ViewExplorar({super.key, this.enPanel = false});
  final bool enPanel;

  @override
  Widget build(BuildContext context) {
    final contenido = DatosSqlite(
      cargar: _cargar,
      contenido: (context, datos) => _body(datos.servicios, datos.prestadores),
    );
    return enPanel
        ? contenido
        : Scaffold(appBar: appbar('Explorar'), body: contenido);
  }

  Future<({List<Servicio> servicios, List<Prestador> prestadores})>
  _cargar() async {
    final db = await BD.conexion();
    return (
      servicios: await Servicio.all(db),
      prestadores: await Prestador.all(db),
    );
  }

  Widget _body(List<Servicio> servicios, List<Prestador> prestadores) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Explorar', style: Estilo.textotitulo),
                SizedBox(height: 8),
                Text(
                  'Servicios y prestadores cerca de ti.',
                  style: Estilo.textochico,
                ),
              ],
            ),
          ),
          const TabBar(
            labelColor: Estilo.colorAzul,
            tabs: [
              Tab(text: 'Servicios'),
              Tab(text: 'Prestadores'),
            ],
          ),
          // Las pestañas muestran dos listas completas. No se filtran datos.
          Expanded(
            child: TabBarView(
              children: [
                _listaServicios(servicios),
                _listaPrestadores(prestadores),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _controles(bool servicios) {
    // Estos campos solo representan el diseño de funciones futuras.
    // readOnly evita editar valores; no hay búsqueda, filtros ni ordenamiento.
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TextField(
            readOnly: true,
            enableInteractiveSelection: false,
            decoration: InputDecoration(
              labelText: 'Buscar servicio o prestador',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            readOnly: true,
            enableInteractiveSelection: false,
            decoration: InputDecoration(
              labelText: 'Categoría',
              hintText: 'Todas',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
          ),
          if (servicios) ...[
            const SizedBox(height: 16),
            const TextField(
              readOnly: true,
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                labelText: 'Ordenar por',
                hintText: 'Nombre',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
            ),
          ],
          const SizedBox(height: 12),
          const Text(
            'Controles de muestra, todavía sin funcionamiento.',
            style: Estilo.textochico,
          ),
        ],
      ),
    );
  }

  Widget _listaServicios(List<Servicio> servicios) {
    // El primer elemento contiene los controles; los demás son las tarjetas.
    // Así toda la pantalla se puede desplazar en teléfonos pequeños.
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: servicios.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              _controles(true),
              if (servicios.isEmpty)
                const Text('No hay servicios disponibles.'),
            ],
          );
        }
        return ItemServicio(servicio: servicios.elementAt(index - 1));
      },
    );
  }

  Widget _listaPrestadores(List<Prestador> prestadores) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: prestadores.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              _controles(false),
              if (prestadores.isEmpty)
                const Text('No hay prestadores disponibles.'),
            ],
          );
        }
        return ItemPrestador(prestador: prestadores.elementAt(index - 1));
      },
    );
  }
}
