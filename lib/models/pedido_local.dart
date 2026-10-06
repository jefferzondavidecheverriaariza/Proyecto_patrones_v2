import 'pedido.dart';

class PedidoLocal extends Pedido {
  PedidoLocal({
    required super.id,
    required super.cliente,
    required super.productos,
    required super.metodoPago,
  }) : super(tipo: 'Para llevar', costoDomicilio: 0);
}
