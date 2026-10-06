import '../models/metodo_pago.dart';
import '../models/pedido.dart';
import '../models/producto.dart';

abstract class PedidoService {
  Pedido crearPedido({
    required String id,
    required String cliente,
    required List<Producto> productos,
    required String tipoEntrega,
    required MetodoPago metodoPago,
  });

  Pedido clonarPedido({
    required Pedido pedidoOriginal,
    required String nuevoId,
    required String nuevoCliente,
  });
}
