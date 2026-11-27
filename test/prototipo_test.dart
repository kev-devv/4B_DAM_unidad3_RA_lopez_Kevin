import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kindo/main.dart';
import 'package:kindo/modelo/actividad.dart';
import 'package:kindo/modelo/bd.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
  });

  late Directory directorio;
  setUp(() async {
    directorio = await Directory.systemTemp.createTemp('kindo_test_');
    await databaseFactory.setDatabasesPath(directorio.path);
  });
  tearDown(() async {
    final db = await BD.conexion();
    await db.close();
    await directorio.delete(recursive: true);
  });

  test('Las solicitudes guardan la foto opcional junto al registro', () async {
    final db = await BD.conexion();
    final foto = Uint8List.fromList([1, 2, 3]);
    await Actividad.registraSolicitud(
      db,
      idCliente: 1,
      idServicio: 2,
      descripcion: 'Fuga con foto',
      foto: foto,
    );
    await Actividad.registraSolicitud(
      db,
      idCliente: 1,
      idServicio: 2,
      descripcion: 'Fuga sin foto',
    );
    await db.close();

    final reabierta = await BD.conexion();
    final actividades = await Actividad.all(reabierta, 1);
    final conFoto = actividades.singleWhere(
      (a) => a.descripcion == 'Fuga con foto',
    );
    final sinFoto = actividades.singleWhere(
      (a) => a.descripcion == 'Fuga sin foto',
    );
    expect(conFoto.servicio, 'Reparación de fugas');
    expect(await conFoto.leeFoto(reabierta), foto);
    expect(await sinFoto.leeFoto(reabierta), isNull);
  });

  testWidgets('Las listas permiten abrir el detalle de un servicio', (
    tester,
  ) async {
    await _abrirPestana(tester, 'Explorar');
    await tester.scrollUntilVisible(
      find.text('Instalación eléctrica'),
      200,
      scrollable: find
          .byWidgetPredicate(
            (widget) =>
                widget is Scrollable &&
                widget.axisDirection == AxisDirection.down,
          )
          .first,
    );
    // Centrar el título evita que la barra inferior cubra el punto de toque.
    await Scrollable.ensureVisible(
      tester.element(find.text('Instalación eléctrica')),
      alignment: 0.3,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Instalación eléctrica'));
    await tester.pumpAndSettle();
    expect(find.text('Detalle del servicio'), findsOneWidget);
    expect(find.text('Prestador: Carlos Méndez'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Buscar, categoría y orden son campos estáticos', (tester) async {
    await _abrirPestana(tester, 'Explorar');
    final campos = tester.widgetList<TextField>(find.byType(TextField));
    expect(campos.length, 3);
    for (final campo in campos) {
      expect(campo.readOnly, isTrue);
      expect(campo.onChanged, isNull);
    }
    expect(find.byType(PopupMenuButton<String>), findsNothing);
    await tester.tap(find.text('Prestadores'));
    await tester.pumpAndSettle();
    expect(find.text('Carlos Méndez'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Actividad refleja SQLite y Acceso conserva su diseño', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final db = await BD.conexion();
      await db.update(
        'actividades',
        {'detalle': 'Precio propuesto: \$330 MXN'},
        where: 'id_actividad = ?',
        whereArgs: [3],
      );
    });
    await _abrirPestana(tester, 'Actividad');
    await tester.tap(find.text('Cotizaciones'));
    await tester.pumpAndSettle();
    expect(find.text('Precio propuesto: \$330 MXN'), findsOneWidget);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pantalla de acceso'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
      isNull,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Explorar se desplaza en un teléfono pequeño', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _abrirPestana(tester, 'Explorar');
    await tester.scrollUntilVisible(
      find.text('Instalación eléctrica'),
      150,
      scrollable: find
          .byWidgetPredicate(
            (widget) =>
                widget is Scrollable &&
                widget.axisDirection == AxisDirection.down,
          )
          .first,
    );
    expect(tester.takeException(), isNull);
  });
}

Future<void> _abrirPestana(WidgetTester tester, String nombre) async {
  await tester.runAsync(() async {
    await tester.pumpWidget(const MyApp());
    await _esperarSqlite(tester);
    await tester.tap(find.text(nombre));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await _esperarSqlite(tester);
  });
}

Future<void> _esperarSqlite(WidgetTester tester) async {
  final indicador = find.byType(CircularProgressIndicator);
  for (
    var intento = 0;
    intento < 100 && indicador.evaluate().isNotEmpty;
    intento++
  ) {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    await tester.pump();
  }
  expect(indicador, findsNothing);
  expect(find.text('No se pudieron cargar los datos.'), findsNothing);
}
