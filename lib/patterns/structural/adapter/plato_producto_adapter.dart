import '../../../models/producto.dart';
import '../../creational/abstract_factory/plato.dart';

// =====================================================
// ADAPTER - ADAPTER
// Adapta Plato (Adaptee) a Producto (Target).
// =====================================================
class PlatoProductoAdapter extends Producto {
  /// Plato adaptado (Adaptee). Permite decorarlo antes de agregarlo al carrito.
  final Plato plato;

  PlatoProductoAdapter(Plato plato, {required String restauranteId})
    : plato = plato,
      super(
        id: '$restauranteId-${plato.nombre}',
        nombre: plato.nombre,
        precio: plato.precio,
        descripcion: 'Preparado especialmente para ti.',
        categoria: 'Plato',
      );
}
