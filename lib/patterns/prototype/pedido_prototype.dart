import '../../models/metodo_pago.dart';
import '../../models/pedido.dart';
import '../../models/pedido_domicilio.dart';
import '../../models/pedido_local.dart';
import '../../models/producto.dart';

class PedidoPrototype {
  final Pedido pedidoOriginal;

  PedidoPrototype(this.pedidoOriginal);

  Pedido clonar({
    String? nuevoId,
    String? nuevoCliente,
    MetodoPago? nuevoMetodoPago,
  }) {
    final id = nuevoId ?? pedidoOriginal.id;

    final cliente = nuevoCliente ?? pedidoOriginal.cliente;

    final metodoPago = nuevoMetodoPago ?? pedidoOriginal.metodoPago;

    final productos = List<Producto>.from(pedidoOriginal.productos);

    if (pedidoOriginal is PedidoDomicilio) {
      return PedidoDomicilio(
        id: id,
        cliente: cliente,
        productos: productos,
        metodoPago: metodoPago,
        costoDomicilio: pedidoOriginal.costoDomicilio,
      );
    }

    if (pedidoOriginal is PedidoLocal) {
      return PedidoLocal(
        id: id,
        cliente: cliente,
        productos: productos,
        metodoPago: metodoPago,
      );
    }

    return Pedido(
      id: id,
      cliente: cliente,
      tipo: pedidoOriginal.tipo,
      metodoPago: metodoPago,
      costoDomicilio: pedidoOriginal.costoDomicilio,
      productos: productos,
    );
  }
}
