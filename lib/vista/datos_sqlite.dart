import 'package:flutter/material.dart';

class DatosSqlite<T> extends StatefulWidget {
  const DatosSqlite({super.key, required this.cargar, required this.contenido});

  final Future<T> Function() cargar;
  final Widget Function(BuildContext, T) contenido;

  @override
  State<DatosSqlite<T>> createState() => _DatosSqliteState<T>();
}

class _DatosSqliteState<T> extends State<DatosSqlite<T>> {
  late Future<T> _consulta;

  @override
  void initState() {
    super.initState();
    _consulta = widget.cargar();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _consulta,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('No se pudieron cargar los datos.'),
                TextButton(
                  onPressed: () => setState(() => _consulta = widget.cargar()),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }
        return widget.contenido(context, snapshot.data as T);
      },
    );
  }
}
