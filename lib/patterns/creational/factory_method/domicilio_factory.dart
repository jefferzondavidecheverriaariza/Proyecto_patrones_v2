import '../../../models/metodo_pago.dart';
import '../../../models/pedido.dart';
import '../../../models/producto.dart';
import '../../../models/pedido_domicilio.dart';
import '../../creational/singleton/app_config.dart';
import 'pedido_factory.dart';

class DomicilioFactory implements PedidoFactory {
  @override
  Pedido crearPedido({
    required String id,
    required String cliente,
    required List<Producto> productos,
    required MetodoPago metodoPago,
    String? direccionEntrega,
    double? costoDomicilio,
  }) {
    return PedidoDomicilio(
      id: id,
      cliente: cliente,
      productos: productos,
      direccionEntrega: direccionEntrega,
      metodoPago: metodoPago,
      costoDomicilio: costoDomicilio ?? AppConfig().tarifaDomicilio,
    );
  }
}
