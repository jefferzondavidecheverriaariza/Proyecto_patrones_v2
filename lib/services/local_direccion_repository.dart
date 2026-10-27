import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/direccion_entrega.dart';
import 'direccion_repository.dart';

class LocalDireccionRepository implements DireccionRepository {
  static const String _prefijoClave = 'queuego.direcciones.';

  Future<SharedPreferences> get _preferencias =>
      SharedPreferences.getInstance();

  String _clave(String usuario) =>
      '$_prefijoClave${Uri.encodeComponent(usuario.trim().toLowerCase())}';

  @override
  Future<List<DireccionEntrega>> listar(String usuario) async {
    final preferencias = await _preferencias;
    final contenido = preferencias.getString(_clave(usuario));
    if (contenido == null) return const [];

    final json = jsonDecode(contenido);
    if (json is! List<dynamic>) {
      throw const FormatException('El listado de direcciones no es válido.');
    }

    return json
        .map(
          (elemento) => DireccionEntrega.fromJson(
            Map<String, dynamic>.from(elemento as Map),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> guardar(String usuario, DireccionEntrega direccion) async {
    final direcciones = (await listar(usuario)).toList();
    final indice = direcciones.indexWhere((item) => item.id == direccion.id);
    if (indice >= 0) {
      direcciones[indice] = direccion;
    } else {
      direcciones.add(direccion);
    }

    final guardarComoPredeterminada =
        direccion.esPredeterminada || direcciones.length == 1;
    for (var index = 0; index < direcciones.length; index++) {
      direcciones[index] = direcciones[index].copyWith(
        esPredeterminada: guardarComoPredeterminada
            ? direcciones[index].id == direccion.id
            : direcciones[index].esPredeterminada,
      );
    }
    if (direcciones.isNotEmpty &&
        !direcciones.any((item) => item.esPredeterminada)) {
      direcciones[0] = direcciones[0].copyWith(esPredeterminada: true);
    }

    await _guardarLista(usuario, direcciones);
  }

  @override
  Future<void> eliminar(String usuario, String direccionId) async {
    final direcciones = (await listar(usuario)).toList();
    final eliminadaPredeterminada = direcciones.any(
      (direccion) => direccion.id == direccionId && direccion.esPredeterminada,
    );
    direcciones.removeWhere((direccion) => direccion.id == direccionId);

    if (eliminadaPredeterminada && direcciones.isNotEmpty) {
      direcciones[0] = direcciones[0].copyWith(esPredeterminada: true);
    }
    await _guardarLista(usuario, direcciones);
  }

  Future<void> _guardarLista(
    String usuario,
    List<DireccionEntrega> direcciones,
  ) async {
    final preferencias = await _preferencias;
    final serializado = jsonEncode(
      direcciones.map((direccion) => direccion.toJson()).toList(),
    );
    final guardado = await preferencias.setString(_clave(usuario), serializado);
    if (!guardado) {
      throw StateError(
        'No fue posible guardar las direcciones en el dispositivo.',
      );
    }
  }
}
