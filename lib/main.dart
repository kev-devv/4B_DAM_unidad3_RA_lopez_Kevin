import 'package:flutter/material.dart';

import 'estilo.dart';
import 'vista/appbar.dart';
import 'vista/view_inicio.dart';
import 'vista/view_explorar.dart';
import 'vista/view_actividad.dart';
import 'vista/view_perfil.dart';
import 'vista/view_acceso.dart';

void main() {
  runApp(const MyApp());
}

// MaterialApp organiza el tema y las rutas de la aplicación.
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kindo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Estilo.colorFondo,
        colorScheme: ColorScheme.fromSeed(seedColor: Estilo.colorAzul),
        // El tema aplica las mismas medidas a los campos y tarjetas de las vistas.
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Estilo.colorBlanco,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 17,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Estilo.colorBorde),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Estilo.colorBorde),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Estilo.colorAzul, width: 2),
          ),
        ),
        cardTheme: CardThemeData(
          color: Estilo.colorBlanco,
          surfaceTintColor: Estilo.colorBlanco,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Estilo.colorBorde),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/explorar': (context) => const ViewExplorar(),
        '/actividad': (context) => const ViewActividad(),
        '/perfil': (context) => const ViewPerfil(),
        '/acceso': (context) => const ViewAcceso(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    // El prototipo abre en Inicio, sin usuario ni sesión.
    // DefaultTabController coordina las pestañas y el deslizamiento.
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: appbar('Kindo'),
        drawer: _drawer(context),
        body: const TabBarView(
          children: [
            ViewInicio(),
            ViewExplorar(enPanel: true),
            ViewActividad(enPanel: true),
            ViewPerfil(enPanel: true),
          ],
        ),
        bottomNavigationBar: Material(
          color: Estilo.colorBlanco,
          child: SafeArea(
            child: TabBar(
              labelColor: Estilo.colorAzul,
              unselectedLabelColor: Estilo.colorSecundario,
              indicatorColor: Estilo.colorAzul,
              labelPadding: EdgeInsets.zero,
              labelStyle: const TextStyle(fontSize: 12),
              tabs: const [
                Tab(icon: Icon(Icons.home_outlined, size: 22), text: 'Inicio'),
                Tab(icon: Icon(Icons.search, size: 22), text: 'Explorar'),
                Tab(
                  icon: Icon(Icons.assignment_outlined, size: 22),
                  text: 'Actividad',
                ),
                Tab(icon: Icon(Icons.person_outline, size: 22), text: 'Perfil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Cada opción del menú lateral abre una pantalla mediante su ruta.
  Drawer _drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/imagenes/logo_kindo_claro.png',
                width: 140,
                height: 48,
                fit: BoxFit.contain,
                semanticLabel: 'Kindo',
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Explorar servicios'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/explorar');
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: const Text('Mi actividad'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/actividad');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Pantalla de acceso'),
            subtitle: const Text('Solo diseño, sin iniciar sesión'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/acceso');
            },
          ),
        ],
      ),
    );
  }
}
