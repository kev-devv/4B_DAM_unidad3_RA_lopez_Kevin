import 'package:flutter/material.dart';

import '../estilo.dart';
import 'appbar.dart';

// Esta pantalla solo muestra la interfaz. No comprueba datos ni crea sesiones.
class ViewAcceso extends StatelessWidget {
  const ViewAcceso({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar('Pantalla de acceso'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Image.asset('assets/imagenes/logo_kindo_claro.png', height: 65),
          const SizedBox(height: 32),
          const Text('Bienvenido de nuevo', style: Estilo.textotitulo),
          const SizedBox(height: 12),
          const Text(
            'Entra a tu cuenta y sigue conectando con tu comunidad.',
            style: Estilo.textochico,
          ),
          const SizedBox(height: 28),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Correo o usuario',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 20),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 28),
          // onPressed: null deja claro que el acceso aún no está implementado.
          ElevatedButton(
            style: Estilo.estiloboton,
            onPressed: null,
            child: const Text('Iniciar sesión'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
