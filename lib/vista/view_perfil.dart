import 'package:flutter/material.dart';

import '../estilo.dart';
import '../modelo/bd.dart';
import '../modelo/cliente.dart';
import 'datos_sqlite.dart';
import 'appbar.dart';

class ViewPerfil extends StatelessWidget {
  const ViewPerfil({super.key, this.enPanel = false});
  final bool enPanel;
  @override
  Widget build(BuildContext context) {
    final contenido = DatosSqlite(cargar: _cargar, contenido: _body);
    return enPanel
        ? contenido
        : Scaffold(appBar: appbar('Mi perfil'), body: contenido);
  }

  Future<Cliente?> _cargar() async => Cliente.local(await BD.conexion());

  Widget _body(BuildContext context, Cliente? cliente) {
    if (cliente == null) {
      return const Center(child: Text('No hay un cliente registrado.'));
    }
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Mi perfil', style: Estilo.textotitulo),
        const SizedBox(height: 8),
        const Text('Datos de la cuenta local.', style: Estilo.textochico),
        const SizedBox(height: 24),
        Card(
          color: Estilo.colorBlanco,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Información personal',
                  style: Estilo.textoencabezado,
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person_outline),
                  ),
                  title: Text(cliente.nombre),
                  subtitle: const Text('Cliente'),
                ),
                _dato('Correo', cliente.correo),
                _dato('Usuario', cliente.usuario),
                _dato('Ciudad', cliente.ciudad),
                OutlinedButton.icon(
                  icon: const Icon(Icons.assignment_outlined),
                  label: const Text('Ver mi actividad'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/actividad');
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const OutlinedButton(onPressed: null, child: Text('Cerrar sesión')),
        const SizedBox(height: 8),
        const Text(
          'El acceso y la sesión se implementarán después.',
          style: Estilo.textochico,
        ),
      ],
    );
  }

  Widget _dato(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(etiqueta, style: Estilo.textochico),
          const SizedBox(height: 4),
          Text(valor, style: Estilo.textonormal),
        ],
      ),
    );
  }
}
