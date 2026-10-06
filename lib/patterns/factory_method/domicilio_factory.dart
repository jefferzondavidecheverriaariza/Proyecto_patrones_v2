import '../../models/metodo_pago.dart';
import '../../models/pedido.dart';
import '../../models/producto.dart';
import '../../models/pedido_domicilio.dart';
import '../singleton/app_config.dart';
import 'pedido_factory.dart';

class DomicilioFactory implements PedidoFactory {
  @override
  Pedido crearPedido({
    required String id,
    required String cliente,
    required List<Producto> productos,
    required MetodoPago metodoPago,
    double? costoDomicilio,
  }) {
    return PedidoDomicilio(
      id: id,
      cliente: cliente,
      productos: productos,
      metodoPago: metodoPago,
      costoDomicilio: costoDomicilio ?? AppConfig().tarifaDomicilio,
    );
  }
}
