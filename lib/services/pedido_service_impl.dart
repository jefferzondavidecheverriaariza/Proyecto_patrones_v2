import '../models/metodo_pago.dart';
import '../models/pedido.dart';
import '../models/producto.dart';
import '../patterns/creational/builder/pedido_builder.dart';
import '../patterns/creational/factory_method/domicilio_factory.dart';
import '../patterns/creational/factory_method/local_factory.dart';
import '../patterns/creational/factory_method/pedido_factory.dart';
import '../patterns/creational/prototype/pedido_prototype.dart';
import 'pedido_service.dart';

class PedidoServiceImpl implements PedidoService {
  @override
  Pedido crearPedido({
    required String id,
    required String cliente,
    required List<Producto> productos,
    required String tipoEntrega,
    required MetodoPago metodoPago,
    String? direccionEntrega,
  }) {
    final builder = PedidoBuilder()
      ..conId(id)
      ..conCliente(cliente)
      ..conTipo(tipoEntrega)
      ..conMetodoPago(metodoPago);
    builder.conDireccionEntrega(direccionEntrega);

    for (final producto in productos) {
      builder.agregarProducto(producto);
    }

    final pedidoConstruido = builder.build();

    final PedidoFactory factory = tipoEntrega == 'Domicilio'
        ? DomicilioFactory()
        : LocalFactory();

    return factory.crearPedido(
      id: pedidoConstruido.id,
      cliente: pedidoConstruido.cliente,
      productos: pedidoConstruido.productos,
      metodoPago: pedidoConstruido.metodoPago,
      direccionEntrega: pedidoConstruido.direccionEntrega,
      costoDomicilio: pedidoConstruido.costoDomicilio,
    );
  }

  @override
  Pedido clonarPedido({
    required Pedido pedidoOriginal,
    required String nuevoId,
    required String nuevoCliente,
  }) {
    final prototype = PedidoPrototype(pedidoOriginal);

    return prototype.clonar(nuevoId: nuevoId, nuevoCliente: nuevoCliente);
  }
}
