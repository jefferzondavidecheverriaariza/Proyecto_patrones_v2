import 'metodo_pago.dart';
import 'producto.dart';

class Pedido {
  final String id;
  final String cliente;
  final List<Producto> productos;
  final String tipo;
  final MetodoPago metodoPago;
  final double costoDomicilio;
  final DateTime fecha;

  Pedido({
    required this.id,
    required this.cliente,
    required this.productos,
    required this.tipo,
    required this.metodoPago,
    this.costoDomicilio = 0,
    DateTime? fecha,
  }) : fecha = fecha ?? DateTime.now();

  double get subtotal {
    return productos.fold(0.0, (suma, producto) => suma + producto.precio);
  }

  double get total {
    return subtotal + costoDomicilio;
  }
}
