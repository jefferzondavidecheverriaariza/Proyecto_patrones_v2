import '../../models/metodo_pago.dart';
import '../../models/pedido.dart';
import '../../models/producto.dart';

abstract class PedidoFactory {
  // =====================================================
  // FACTORY METHOD
  // =====================================================

  Pedido crearPedido({
    required String id,
    required String cliente,
    required List<Producto> productos,
    required MetodoPago metodoPago,
    double? costoDomicilio,
  });
}
