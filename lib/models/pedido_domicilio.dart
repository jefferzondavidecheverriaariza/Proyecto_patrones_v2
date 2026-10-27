import 'pedido.dart';

class PedidoDomicilio extends Pedido {
  PedidoDomicilio({
    required super.id,
    required super.cliente,
    required super.productos,
    required super.direccionEntrega,
    required super.metodoPago,
    required super.costoDomicilio,
  }) : super(tipo: 'Domicilio');
}
