import 'producto.dart';

class CarritoItem {
  final Producto producto;
  int cantidad;

  CarritoItem({
    required this.producto,
    this.cantidad = 1,
  });

  double get subtotal {
    return producto.precio * cantidad;
  }

  void incrementar() {
    cantidad++;
  }

  void disminuir() {
    if (cantidad > 1) {
      cantidad--;
    }
  }
}