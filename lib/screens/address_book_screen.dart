import 'package:flutter/material.dart';

import '../models/direccion_entrega.dart';

class AddressBookScreen extends StatefulWidget {
  final List<DireccionEntrega> direcciones;
  final String? error;
  final bool cargando;
  final Future<List<DireccionEntrega>> Function(DireccionEntrega) onSave;
  final Future<List<DireccionEntrega>> Function(String) onDelete;
  final Future<List<DireccionEntrega>> Function() onRetry;

  const AddressBookScreen({
    super.key,
    required this.direcciones,
    required this.error,
    required this.cargando,
    required this.onSave,
    required this.onDelete,
    required this.onRetry,
  });

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  late List<DireccionEntrega> direcciones = List.of(widget.direcciones);
  late String? errorCarga = widget.error;
  bool guardando = false;

  Future<void> _editarDireccion([DireccionEntrega? existente]) async {
    final formulario = GlobalKey<FormState>();
    final etiquetaController = TextEditingController(
      text: existente?.etiqueta ?? '',
    );
    final direccionController = TextEditingController(
      text: existente?.direccion ?? '',
    );
    final ciudadController = TextEditingController(
      text: existente?.ciudad ?? '',
    );
    final referenciaController = TextEditingController(
      text: existente?.referencia ?? '',
    );
    var predeterminada = existente?.esPredeterminada ?? direcciones.isEmpty;

    final resultado = await showDialog<DireccionEntrega>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            existente == null ? 'Nueva dirección' : 'Editar dirección',
          ),
          content: SizedBox(
            width: 420,
            child: Form(
              key: formulario,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: etiquetaController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        hintText: 'Casa, trabajo...',
                        prefixIcon: Icon(Icons.bookmark_border),
                      ),
                      validator: _requerido,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: direccionController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Dirección',
                        hintText: 'Calle, carrera, número...',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      validator: _requerido,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: ciudadController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Ciudad',
                        prefixIcon: Icon(Icons.location_city_outlined),
                      ),
                      validator: _requerido,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: referenciaController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Indicaciones (opcional)',
                        hintText: 'Apto, torre, punto de referencia...',
                        prefixIcon: Icon(Icons.info_outline),
                      ),
                      minLines: 1,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: predeterminada,
                      onChanged: (value) {
                        setDialogState(() => predeterminada = value);
                      },
                      title: const Text('Usar como dirección principal'),
                      secondary: const Icon(Icons.star_outline),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                if (!formulario.currentState!.validate()) return;
                Navigator.pop(
                  dialogContext,
                  DireccionEntrega(
                    id:
                        existente?.id ??
                        DateTime.now().microsecondsSinceEpoch.toString(),
                    etiqueta: etiquetaController.text.trim(),
                    direccion: direccionController.text.trim(),
                    ciudad: ciudadController.text.trim(),
                    referencia: referenciaController.text.trim(),
                    esPredeterminada: predeterminada,
                  ),
                );
              },
              child: const Text('Guardar dirección'),
            ),
          ],
        ),
      ),
    );

    etiquetaController.dispose();
    direccionController.dispose();
    ciudadController.dispose();
    referenciaController.dispose();
    if (resultado == null || !mounted) return;

    setState(() => guardando = true);
    try {
      final actualizadas = await widget.onSave(resultado);
      if (!mounted) return;
      setState(() => direcciones = actualizadas);
      _mensaje('Dirección guardada.');
    } on Exception catch (error) {
      if (mounted) _mensaje('No se pudo guardar la dirección: $error');
    } finally {
      if (mounted) setState(() => guardando = false);
    }
  }

  String? _requerido(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Este campo es obligatorio.';
    }
    return null;
  }

  Future<void> _eliminarDireccion(DireccionEntrega direccion) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar dirección'),
        content: Text('¿Quieres eliminar "${direccion.etiqueta}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;

    setState(() => guardando = true);
    try {
      final actualizadas = await widget.onDelete(direccion.id);
      if (!mounted) return;
      setState(() => direcciones = actualizadas);
      _mensaje('Dirección eliminada.');
    } on Exception catch (error) {
      if (mounted) _mensaje('No se pudo eliminar la dirección: $error');
    } finally {
      if (mounted) setState(() => guardando = false);
    }
  }

  void _mensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<List<DireccionEntrega>>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          Navigator.pop(context, List.unmodifiable(direcciones));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Mis direcciones')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: widget.cargando || guardando
                ? const Center(child: CircularProgressIndicator())
                : errorCarga != null && direcciones.isEmpty
                ? _errorCarga()
                : _contenido(),
          ),
        ),
        floatingActionButton: errorCarga != null && direcciones.isEmpty
            ? null
            : FloatingActionButton.extended(
                onPressed: guardando ? null : () => _editarDireccion(),
                icon: const Icon(Icons.add),
                label: const Text('Agregar dirección'),
              ),
      ),
    );
  }

  Widget _errorCarga() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_outlined, size: 44),
          const SizedBox(height: 12),
          Text(errorCarga!, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _reintentar,
            icon: const Icon(Icons.refresh),
            label: const Text('Intentar de nuevo'),
          ),
        ],
      ),
    );
  }

  Future<void> _reintentar() async {
    try {
      final actualizadas = await widget.onRetry();
      if (mounted) {
        setState(() {
          direcciones = actualizadas;
          errorCarga = null;
        });
      }
    } on Exception catch (error) {
      if (mounted) {
        setState(() => errorCarga = 'No se pudieron cargar las direcciones.');
        _mensaje('No se pudieron cargar las direcciones: $error');
      }
    }
  }

  Widget _contenido() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEEE8),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Row(
            children: [
              Icon(Icons.local_shipping_outlined, color: Color(0xFFE85C36)),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Guarda tus lugares frecuentes para agilizar tus próximos pedidos.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (direcciones.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 44),
            child: Column(
              children: [
                Icon(
                  Icons.location_off_outlined,
                  size: 56,
                  color: Color(0xFF9A9EA6),
                ),
                SizedBox(height: 14),
                Text(
                  'Aún no tienes direcciones',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 6),
                Text(
                  'Agrega una para recibir tus pedidos en casa.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF777D87)),
                ),
              ],
            ),
          )
        else
          ...direcciones.map(_tarjetaDireccion),
      ],
    );
  }

  Widget _tarjetaDireccion(DireccionEntrega direccion) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFFFEEE8),
              foregroundColor: const Color(0xFFE85C36),
              child: Icon(
                direccion.etiqueta.toLowerCase().contains('trab')
                    ? Icons.work_outline
                    : Icons.home_outlined,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        direccion.etiqueta,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      if (direccion.esPredeterminada)
                        const Chip(
                          label: Text('Principal'),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          labelStyle: TextStyle(fontSize: 11),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    direccion.resumen,
                    style: const TextStyle(
                      color: Color(0xFF777D87),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (accion) {
                if (accion == 'editar') {
                  _editarDireccion(direccion);
                } else {
                  _eliminarDireccion(direccion);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'editar', child: Text('Editar')),
                PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
