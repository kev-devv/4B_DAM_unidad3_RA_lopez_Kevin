import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../modelo/actividad.dart';
import '../modelo/bd.dart';
import '../modelo/cliente.dart';
import '../modelo/servicio.dart';
import 'appbar.dart';
import 'view_actividad.dart';

class ViewSolicitud extends StatefulWidget {
  const ViewSolicitud({super.key, required this.servicio});

  final Servicio servicio;

  @override
  State<ViewSolicitud> createState() => _ViewSolicitudState();
}

class _ViewSolicitudState extends State<ViewSolicitud> {
  final _formulario = GlobalKey<FormState>();
  final _descripcion = TextEditingController();
  final _camara = ImagePicker();
  Uint8List? _foto;
  bool _ocupado = false;
  String? _mensaje;

  @override
  void dispose() {
    _descripcion.dispose();
    super.dispose();
  }

  Future<void> _tomarFoto() async {
    setState(() {
      _ocupado = true;
      _mensaje = null;
    });
    try {
      final archivo = await _camara.pickImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 70,
      );
      if (archivo == null) return;
      if (await archivo.length() > 750 * 1024) {
        _mensaje =
            'La foto supera 750 KB. Toma otra o continúa sin adjuntarla.';
        return;
      }
      final foto = await archivo.readAsBytes();
      if (mounted) _foto = foto;
    } on PlatformException catch (error) {
      _mensaje =
          error.code == 'camera_access_denied' ||
              error.code == 'camera_access_restricted'
          ? 'El acceso a la cámara está desactivado. Puedes revisarlo en Ajustes o continuar sin foto.'
          : 'No se pudo abrir la cámara. Puedes continuar sin foto.';
    } catch (_) {
      _mensaje = 'No se pudo adjuntar la foto.';
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  Future<void> _guardar() async {
    if (!_formulario.currentState!.validate()) return;
    final descripcion = _descripcion.text.trim();
    setState(() {
      _ocupado = true;
      _mensaje = null;
    });
    try {
      final db = await BD.conexion();
      final cliente = await Cliente.local(db);
      if (cliente == null) {
        _mensaje = 'Se necesita un cliente registrado para crear la solicitud.';
        return;
      }
      await Actividad.registraSolicitud(
        db,
        idCliente: cliente.id,
        idServicio: widget.servicio.id,
        descripcion: descripcion,
        foto: _foto,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Solicitud guardada')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (_) => const ViewActividad()),
      );
    } catch (_) {
      _mensaje = 'No se pudo guardar la solicitud. Intenta de nuevo.';
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final foto = _foto;
    return Scaffold(
      appBar: appbar('Nueva solicitud'),
      body: Form(
        key: _formulario,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              widget.servicio.nombre,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descripcion,
              readOnly: _ocupado,
              minLines: 3,
              maxLines: 5,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: 'Describe el problema',
              ),
              validator: (texto) => texto == null || texto.trim().isEmpty
                  ? 'Escribe una descripción.'
                  : null,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _ocupado ? null : _tomarFoto,
              icon: const Icon(Icons.camera_alt_outlined),
              label: Text(
                foto == null ? 'Tomar foto (opcional)' : 'Tomar otra foto',
              ),
            ),
            if (foto != null) ...[
              Image.memory(foto, height: 220, fit: BoxFit.contain),
              TextButton(
                onPressed: _ocupado ? null : () => setState(() => _foto = null),
                child: const Text('Quitar foto'),
              ),
            ],
            if (_mensaje != null) Text(_mensaje!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _ocupado ? null : _guardar,
              child: const Text('Guardar solicitud'),
            ),
            if (_ocupado) const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
