import 'package:flutter/material.dart';

import '../estilo.dart';
import '../modelo/prestador.dart';
import 'view_detalle_prestador.dart';

// Tarjeta reutilizable que recibe sus datos mediante el constructor.
class ItemPrestador extends StatelessWidget {
  const ItemPrestador({super.key, required this.prestador});
  final Prestador prestador;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Estilo.colorBlanco,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const CircleAvatar(child: Icon(Icons.person_outline)),
        title: Text(
          prestador.nombre,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Estilo.colorOscuro,
          ),
        ),
        subtitle: Text(
          '${prestador.especialidad}\nCalificación de ejemplo: ${prestador.calificacion}',
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewDetallePrestador(prestador: prestador),
            ),
          );
        },
      ),
    );
  }
}
