import '../../../models/carrito_item.dart';

// =====================================================
// FACADE - SUBSISTEMA
// Reglas de validación previas a confirmar un pedido.
// =====================================================
class ValidadorCarrito {
  const ValidadorCarrito();

  /// Devuelve el mensaje de error, o null si el carrito es válido.
  String? validar(List<CarritoItem> carrito) {
    if (carrito.isEmpty) {
      return 'El carrito está vacío.';
    }

    return null;
  }
}
