import '../../../models/producto.dart';
import '../../creational/abstract_factory/bebida.dart';

// =====================================================
// ADAPTER - ADAPTER
// Adapta Bebida (Adaptee) a Producto (Target).
// =====================================================
class BebidaProductoAdapter extends Producto {
  BebidaProductoAdapter(Bebida bebida, {required String restauranteId})
    : super(
        id: '$restauranteId-${bebida.nombre}',
        nombre: bebida.nombre,
        precio: bebida.precio,
        descripcion: 'Bebida para acompañar tu pedido.',
        categoria: 'Bebida',
      );
}
