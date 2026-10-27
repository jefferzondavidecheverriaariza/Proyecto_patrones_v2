import '../../../models/carrito_item.dart';
import '../../../models/producto.dart';

// =====================================================
// FACADE
// =====================================================
class ConversorCarrito {
  const ConversorCarrito();

  /// Expande cada línea del carrito según su cantidad.
  List<Producto> aProductos(List<CarritoItem> carrito) {
    return [
      for (final item in carrito)
        for (var i = 0; i < item.cantidad; i++) item.producto,
    ];
  }

  /// Agrupa productos repetidos en líneas de carrito.
  List<CarritoItem> desdeProductos(Iterable<Producto> productos) {
    final items = <CarritoItem>[];

    for (final producto in productos) {
      final indice = items.indexWhere(
        (item) => item.producto.id == producto.id,
      );

      if (indice >= 0) {
        items[indice].incrementar();
      } else {
        items.add(CarritoItem(producto: producto));
      }
    }

    return items;
  }
}
